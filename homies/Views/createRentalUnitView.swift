//
//  createRentalUnitView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/29/23.
//

import SwiftUI
import MapKit
struct createRentalUnitView: View {
    @EnvironmentObject var manager : MapManager
    @State private var inputLatitude = ""
    @State private var inputLongitude = ""
    @State private var address = ""
    @State private var inputPrice = ""
    @State private var customName = ""
    @State private var numBath = ""
    @State private var numBed = ""
    @State private var petPolicy = false
    @State private var leaseStart = "SP 2023"
    @State private var leaseEnd = "FA 2024"
    @State private var rentalUnitType = buildingType.any
    @State private var selectedAmenities: Set<amenities> = []
    @State private var selectedFeatures: Set<features> = []
    @State private var selectedSafety: Set<safety> = []
    @State private var showSheet = false
    @State private var image = UIImage()
    @State private var propertyID = UUID()
    let leaseTerm = ["SP 2023","FA 2024","SP 2024"]
    var body: some View {
            ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                Text("Please enter your rental unit information")
                    .font(.title2)
                    .fontWeight(.semibold)
                Group {
                    TextField("Latitude", text: $inputLatitude)
                    TextField("Longitude", text: $inputLongitude)
                    TextField("Address", text: $address)
                    TextField("Price", text: $inputPrice)
                    TextField("Custom Name", text: $customName)
                    TextField("Number of Bathrooms", text: $numBath)
                    TextField("Number of Bedrooms", text: $numBed)
                    HStack{
                        Text("Lease Start")
                        Picker("Lease Start",selection: $leaseStart){
                            ForEach(leaseTerm,id:\.self){
                                Text($0)
                            }
                        }
                    }
                    HStack{
                        Text("Lease End")
                        Picker("Lease End",selection: $leaseEnd){
                            ForEach(leaseTerm,id:\.self){
                                Text($0)
                            }
                        }
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Toggle("Is your rental unit pet-friendly?", isOn: $petPolicy)
                Group {
                    Text("Rental unit type:")
                        .font(.headline)
                        .fontWeight(.medium)
                    Picker(selection: $rentalUnitType, label: Text("Select rental unit type")) {
                        Text("Any").tag(buildingType.any)
                        Text("Rental Unit").tag(buildingType.rentalUnits)
                        Text("House").tag(buildingType.House)
                        Text("Condo").tag(buildingType.Condos)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.top)
                Group{
                    Text("Available amenities")
                    ForEach(amenities.allCases, id: \.self){ amenity in
                        Toggle(amenity.rawValue, isOn: Binding<Bool>(
                            get: { self.selectedAmenities.contains(amenity) },
                            set: { if $0 { self.selectedAmenities.insert(amenity) } else { self.selectedAmenities.remove(amenity) } }
                        ))
                    }
                }
                Group{
                    Text("Avaliable features")
                    ForEach(features.allCases, id: \.self){
                        feature in
                        Toggle(feature.rawValue, isOn: Binding<Bool>(
                            get: { self.selectedFeatures.contains(feature) },
                            set: { if $0 { self.selectedFeatures.insert(feature) } else { self.selectedFeatures.remove(feature) } }
                        ))                    }
                }
                Group{
                    Text("Avaliable safety")
                    ForEach(safety.allCases, id: \.self){
                        i in
                        Toggle(i.rawValue, isOn: Binding<Bool>(
                            get: { self.selectedSafety.contains(i) },
                            set: { if $0 { self.selectedSafety.insert(i) } else { self.selectedSafety.remove(i) } }
                        ))
                    }
                }
            }.sheet(isPresented: $showSheet){
                ImagePicker(selectedImage: self.$image,uploadPath: "property/\(propertyID)/photo")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            Button("upload sample picture:"){
                    showSheet.toggle()
            }
            Button("add to your rental units"){
                manager.addRentalProperty(rentalUnit: Place(placeMark:MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (inputLatitude as NSString).doubleValue, longitude: (inputLongitude as NSString).doubleValue)),ID: propertyID, favorite: false, customName: customName, photo: "", price: Int(inputPrice)!, type: buildingType.any, numBed: Int(numBed)!, numBath: Int(numBath)!, petPolicy: petPolicy, amenities: Array(selectedAmenities), features: Array(selectedFeatures), safety: Array(selectedSafety), leaseStart: leaseStart, leaseEnd: leaseEnd, userID: manager.userID, address: address))
            }
        }
    }
}

struct createRentalUnitView_Previews: PreviewProvider {
    static var previews: some View {
        createRentalUnitView().environmentObject(MapManager())
    }
}
