//
//  Place.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/13/23.
//

import Foundation
import MapKit

class Place : NSObject, Identifiable ,MKAnnotation{
    var placeMark : MKPlacemark
    var ID : UUID
    var favorite : Bool = false
    var customName : String?
    var photo : String?
    var price : Int
    var numBed : Int
    var numBath : Int
    var type : buildingType
    var petPolicy: Bool
    var amenities : [amenities]
    var features : [features]
    var safety : [safety]
    var leaseStart : String
    var leaseEnd : String
    var userID : String
    var address : String
    
    enum CodingKeys : String, CodingKey, Codable{
        case placeMark,ID,favorite,customName,photo,price,numBed,numBath,type,petPolicy,amenities,features,safety,leaseStart,leaseEnd,userID,address
    }
    static var standard = Place(placeMark:MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.8017390346291, longitude: -77.8543146925926)),ID: UUID(), favorite: true,customName: "no name", photo:"no photo", price: 500, type:.any,numBed: 1,numBath: 1,petPolicy: true,amenities: [.airconditioning],features: [.elevator],safety: [.smokealarm],leaseStart: "FA2023", leaseEnd: "SP2024",userID: "5555", address:"114 East Hamilton")

    init(placeMark:MKPlacemark,ID: UUID,favorite: Bool, customName:String?, photo: String?, price: Int, type: buildingType,numBed:Int, numBath: Int, petPolicy:Bool, amenities: [amenities],features: [features],safety: [safety],leaseStart : String, leaseEnd : String, userID : String, address: String){
        self.placeMark = placeMark
        self.ID = ID
        self.favorite = favorite
        self.customName = customName
        self.photo = photo
        self.price = price
        self.type = type
        self.numBed = numBed
        self.numBath = numBath
        self.petPolicy = petPolicy
        self.amenities = amenities
        self.features = features
        self.safety = safety
        self.leaseStart = leaseStart
        self.leaseEnd = leaseEnd
        self.userID = userID
        self.address = address
    }
}
//
//extension Place{
//    convenience init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        placeMark = values.decode(MKPlacemark.self, forKey: .placeMark)
//    }
//}

extension Place {
    var title : String? { self.placeMark.name ?? self.customName }
    var name : String {customName ?? placeMark.name ?? "No Name"}
    var coordinate : CLLocationCoordinate2D {self.placeMark.coordinate}
}
