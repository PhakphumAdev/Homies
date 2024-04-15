//
//  MapManager.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/13/23.
//

import Foundation
import MapKit
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import CodableFirebase
import GoogleSignIn

@MainActor
class MapManager : NSObject , ObservableObject{
    @AppStorage("isSignedIn") var isSignedIn = false
    @Published var locationModel : LocationModel
    @Published var mapType : MKMapType
    @Published var region : MKCoordinateRegion
    @Published var userTrackingMode : MKUserTrackingMode
    @Published var address : String
    @Published var nearbyRentalUnits = [Place]()
//    @Published var fetchedProperties = [firebasePlace]()
    @Published var sortingType : sorting
    @Published var showPlace : Bool

    @Published var propertyPath : DatabaseReference? = {
        return Database.database().reference().child("homies")
    }()
    
    @Published var filterProperty : filterPlace?
    @Published var storage : StorageReference!
    @Published var ref : DatabaseReference!
    @Published var selectedPlace : Place?
    @Published var userID = "no user id"
    @Published var destID = "no dest id"
    @Published var userDisplayName = ""
    @Published var userInbox = [userInboxModel]()
    var userRecentLocation : CLLocationCoordinate2D?
    let span = 0.01
    let locationManager : CLLocationManager
    
    @Published var messages : [Chat] = []
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private lazy var userdbPath: DatabaseReference? = {
        return Database.database().reference().child("users").child(userID).child("chat").child(self.destID)
    }()
    
    private lazy var userinboxPath : DatabaseReference? = {
        return Database.database().reference().child("users").child(userID).child("chat")
    }()
    
    @Published var userProfileImage : UIImage
    override init(){
        let _locationModel = LocationModel()
        address = ""
        userProfileImage = UIImage(systemName: "photo")!
        mapType = .standard
        sortingType = .earliestmovein
        showPlace = false
        region = MKCoordinateRegion(center: _locationModel.centerCoord.coordCL2D, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        locationModel = _locationModel
        locationManager = CLLocationManager()
        userTrackingMode = .none
        storage = Storage.storage().reference()
        ref = Database.database().reference()
        super.init()
        self.getUserId()
        self.fetchProperties()
        locationManager.delegate = self
        locationManager.desiredAccuracy = .leastNonzeroMagnitude
    }
    func loginUser(email: String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed due to error:", err)
                return
            }
            self.isSignedIn = true
            self.getUserId()
            print("Successfully logged in with ID: \(result?.user.uid ?? "")")
            return
        }
    }


    func createUser(email: String, password:String){
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, err in
            if let err = err {
                print("Failed due to error:", err)
                return
            }
            print("Successfully created account with ID: \(result?.user.uid ?? "")")
            return
        })
    }
    
    func listen(){
        guard let userdbPath = userdbPath else {
          return
        }
        userdbPath
          .observe(.childAdded) { [weak self] snapshot in
            guard
            let self = self,
              var json = snapshot.value as? [String: Any]
            else {
              return
            }
            json["id"] = snapshot.key
            do {
              let messageData = try JSONSerialization.data(withJSONObject: json)
              let message = try self.decoder.decode(Chat.self, from: messageData)
                print("new message coming in")
                print(message)
              self.messages.append(message)
            } catch {
              print("Error retrieving messages: \(error)")
            }
          }
    }
    
    func fetchCurrentUserInbox(){
        guard let userinboxPath = userinboxPath else{
            return
        }
        userinboxPath
          .observe(.childAdded) { [weak self] snapshot in
            guard
            let self = self,
              var json = snapshot.value as? [String: Any]
            else {
              return
            }
              self.userInbox.append((userInboxModel(displayName: snapshot.key, destID: snapshot.key)))
          }
    }
    
    func stopFetchCurrentUserInbox(){
        self.userInbox.removeAll()
        userinboxPath?.removeAllObservers()
    }
    func stopListen(){
        messages = []
        userdbPath?.removeAllObservers()
    }
    
    func getUserDisplayName() -> String {
        let user = Auth.auth().currentUser
        if let user = user {
            return user.displayName ?? ""
        }
        return ""
    }
    func fetchProperties(){
        guard let propertyPath = propertyPath else {
                return
        }
        propertyPath
            .observe(.childAdded) { [weak self] snapshot in
            guard
            let self = self,
              var json = snapshot.value as? [String: Any]
            else {
              return
            }
            json["id"] = snapshot.key
            do {
                    let firebasePropertyData = try JSONSerialization.data(withJSONObject: json)
                    let property = try self.decoder.decode(firebasePlace.self, from: firebasePropertyData)
//                print("new data coming in")
//                print(property)
                    self.nearbyRentalUnits.append(self.firebaseToPlace(rtPlace: property))
            } catch {
              print("Error retrieving messages: \(error)")
            }
          }
    }
//    
//    func printLocalProperty(){
//        print("local:")
//        for i in self.nearbyRentalUnits{
//            print(i.ID)
//        }
//    }
//
    func getPropertyPicture(propertyID : String, completion: @escaping (UIImage) -> Void) {
        storage.child("property").child(propertyID).child("photo").getData(maxSize: 1 * 2048 * 2048){
            data, error in
            if let error = error{
                print("Error downloading image: \(error.localizedDescription)")
            }
            else{
                if let data = data, let image = UIImage(data:data){
                    completion(image)
                }
                else{
                    print("Error converting data to image")
                }
            }
        }
    }
    func sendMessage(newMessageText : String, userDest : String) {
      if (newMessageText != "") {
        // sending text
          self.ref.child("users").child(userID).child("chat").child(userDest).childByAutoId().setValue(["text": newMessageText, "displayName": Auth.auth().currentUser!.displayName])
          self.ref.child("users").child(userDest).child("chat").child(userID).childByAutoId().setValue(["text": newMessageText, "displayName": Auth.auth().currentUser!.displayName])
      }
    }
    
    func updateDisplayName(displayName : String) {
      // On creation of new user, set display name
      let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
      changeRequest.displayName = displayName
      changeRequest.commitChanges { error in
        if let error = error {
            print("got some sort of error in display name \(error.localizedDescription)")
        } else {
          print("display was supposedly a success...")
        }
      }
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("sign out ok!")
            isSignedIn = false
        } catch let signOutError as NSError {
            print("oh no sign out error why?: \(signOutError.localizedDescription)")
        }
    }
    
    func placeToFirebase(rentalUnit: Place) -> firebasePlace{
        let latitude = rentalUnit.placeMark.coordinate.latitude
        let longitude = rentalUnit.placeMark.coordinate.longitude
        let id = rentalUnit.ID
        let photo = rentalUnit.photo!
        let price = rentalUnit.price
        let customName = rentalUnit.customName
        let numBed = rentalUnit.numBed
        let numBath = rentalUnit.numBath
        let type = rentalUnit.type.rawValue
        let petPolicy = rentalUnit.petPolicy
        var amenities = [String]()
        for i in rentalUnit.amenities{
            amenities.append(i.rawValue)
        }
        var features = [String]()
        for i in rentalUnit.features{
            features.append(i.rawValue)
        }
        var safety = [String]()
        for i in rentalUnit.safety{
            safety.append(i.rawValue)
        }
        let leaseStart = rentalUnit.leaseStart
        let leaseEnd = rentalUnit.leaseEnd
        let userID = rentalUnit.userID
        let address = rentalUnit.address
        
        let ret = firebasePlace(latitude: latitude, longitude: longitude, customName: customName!, id: id, photoUrl: photo, price: price, numBed: numBed, numBath: numBath, type: type, petPolicy: petPolicy, amenities: amenities,features: features ,safety: safety, leaseStart: leaseStart, leaseEnd: leaseEnd, userID: userID, address: address)
        
        return ret
    }
    
    func firebaseToPlace(rtPlace: firebasePlace) -> Place{
        let placeMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: rtPlace.latitude, longitude: rtPlace.longitude))
        let id = rtPlace.id
        let customName = rtPlace.customName
        let photo = rtPlace.photoUrl
        let price = rtPlace.price
        let numBed = rtPlace.numBed
        let numBath = rtPlace.numBath
        var type = buildingType.any
        if(rtPlace.type=="any"){
            type = buildingType.any
        }
        else if(rtPlace.type=="rentalunits"){
            type = .rentalUnits
        }
        else if(rtPlace.type=="house"){
            type = .House
        }
        else if(rtPlace.type=="condos"){
            type = .Condos
        }
        let petPolicy = rtPlace.petPolicy
        var amenities = [amenities]()
        for i in rtPlace.amenities{
            switch i {
            case "washerdryer":
                amenities.append(.washerdryer)
            case "dishwasher":
                amenities.append(.dishwasher)
            case "furnished":
                amenities.append(.furnished)
            case "wifi":
                amenities.append(.wifi)
            case "fireplace":
                amenities.append(.fireplace)
            case "kitchen":
                amenities.append(.kitchen)
            case "heating":
                amenities.append(.heating)
            case "tv":
                amenities.append(.tv)
            case "airconditioning":
                amenities.append(.airconditioning)
            case "storageavaliable":
                amenities.append(.storageavaliable)
            case "privateoutdoorspace":
                amenities.append(.privateoutdoorspace)
            default: print("this is impossible")
            }
        }
        
        var features = [features]()
        for i in rtPlace.features{
            switch i {
            case "laundryroom":
                features.append(.laundryroom)
            case "parking":
                features.append(.parking)
            case "gym":
                features.append(.gym)
            case "publicoutdoorspace":
                features.append(.publicoutdoorspace)
            case "elevator":
                features.append(.elevator)
            case "pool":
                features.append(.pool)
            case "smokefree":
                features.append(.smokefree)
            default: print("this is impossible")
            }
        }
        var safety = [safety]()
        for i in rtPlace.safety{
            switch i {
            case "smokealarm":
                safety.append(.smokealarm)
            case "carbonmonoxidealarm":
                safety.append(.carbonmonoxidealarm)
            default: print("this is impossible")
            }
        }
        let leaseStart = rtPlace.leaseStart
        let leaseEnd = rtPlace.leaseEnd
        let userID = rtPlace.userID
        let address = rtPlace.address
        let retPlace = Place(placeMark: placeMark, ID: id, favorite: false, customName: customName, photo: photo, price: price, type: type, numBed: numBed, numBath: numBath, petPolicy: petPolicy, amenities: amenities, features: features, safety: safety, leaseStart: leaseStart, leaseEnd: leaseEnd, userID: userID, address: address)
        return retPlace
    }
    
    func addRentalProperty(rentalUnit : Place){
        let toFirebase = placeToFirebase(rentalUnit: rentalUnit)
        let data = try! FirebaseEncoder().encode(toFirebase)
        self.ref.child("homies").child(rentalUnit.ID.uuidString).setValue(data)
        self.ref.child("users").child(userID).child("properties").child(rentalUnit.ID.uuidString).setValue(data)
    }
    
    func getUserId(){
        let user = Auth.auth().currentUser
        if let user = user {
            self.userID = user.uid
        }
    }
    
    func getUserProfilePicture(){
        storage.child("users").child(userID).child("images").child("profilepicture").getData(maxSize: 1 * 2048 * 2048){
            data, error in
            if let error = error{
                print("Error downloading image: \(error.localizedDescription)")
            }
            else{
                self.userProfileImage = UIImage(data: data!)!
            }
        }
    }
    
    func showornoshow(rentalUnit : Place) -> Bool{
        if(self.filterProperty != nil){
            print("showornoshow")
            print(self.filterProperty!)
            if(self.filterProperty?.priceRange == 1 && rentalUnit.price>1000){
                return false
            }
            else if(self.filterProperty?.priceRange == 2 && (rentalUnit.price<1000 || rentalUnit.price>2000)){
                return false
            }
            else if(self.filterProperty?.priceRange == 3 && (rentalUnit.price<2000 || rentalUnit.price>3000)){
                return false
            }
            else if(self.filterProperty?.priceRange == 4 && rentalUnit.price<3000){
                return false
            }
            if(self.filterProperty?.leaseStart != rentalUnit.leaseStart && self.filterProperty?.leaseStart != "any"){
                return false
            }
            if(self.filterProperty?.leaseEnd != rentalUnit.leaseEnd && self.filterProperty?.leaseEnd != "any"){
                return false
            }
            if(self.filterProperty?.nRoom != 0){
                if(self.filterProperty?.nRoom == 3 && rentalUnit.numBed<3){
                    return false
                }
                if(self.filterProperty?.nRoom != rentalUnit.numBed && self.filterProperty?.nRoom != 3){
                    return false
                }
            }
            if(self.filterProperty?.nBath != 0){
                if(self.filterProperty?.nBath == 3 && rentalUnit.numBath<3){
                    return false
                }
                if(self.filterProperty?.nBath != rentalUnit.numBath && self.filterProperty?.nBath != 3){
                    return false
                }
            }
            for i in self.filterProperty?.filterAmenities ?? []{
                if(!rentalUnit.amenities.contains(i)){
                    return false
                }
            }
            for i in self.filterProperty?.filterSafety ?? []{
                if(!rentalUnit.safety.contains(i)){
                    return false
                }
            }
            for i in self.filterProperty?.filterFeatures ?? []{
                if(!rentalUnit.features.contains(i)){
                    return false
                }
            }
            if(self.filterProperty?.bType == .rentalUnits && rentalUnit.type != .rentalUnits && rentalUnit.type != .any){
                return false
            }
            if(self.filterProperty?.bType == .House && rentalUnit.type != .House && rentalUnit.type != .any){
                return false
            }
            if(self.filterProperty?.bType == .House && rentalUnit.type != .House && rentalUnit.type != .any){
                return false
            }
            if(self.filterProperty?.petPolicy != rentalUnit.petPolicy){
                return false
            }
            return true
        }
        else{
            return true
        }
    }
}

extension Coord {
    var coordCL2D : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
extension Spot  {
    var coordinate : CLLocationCoordinate2D {
        self.coord.coordCL2D
    }
}



