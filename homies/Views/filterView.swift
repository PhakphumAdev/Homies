//
//  filterView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/16/23.
//

import SwiftUI

struct filterView: View {
    @EnvironmentObject var manager : MapManager
    @State private var showFilter = false
    @State private var priceRange = 0
    @State private var nRoom = 0
    @State private var nBath = 0
    @State private var leaseStart = "SP 2023"
    @State private var leaseEnd = "SP 2023"
    @State private var bType = buildingType.any
    @State private var filterFeatures: Set<features> = []
    @State private var filterAmenities: Set<amenities> = []
    @State private var filterSafety: Set<safety> = []
    @State private var petPolciy = false

    var body: some View {
        VStack {
            Button(action: {
                showFilter.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
            }
        }
        .sheet(isPresented: $showFilter) {
            NavigationView {
                Form {
                    Section(header: Text("Price Range")) {
                        Picker(selection: $priceRange, label: Text("Price Range")) {
                            Text("Any").tag(0)
                            Text("Under $1000").tag(1)
                            Text("$1000-$2000").tag(2)
                            Text("$2000-$3000").tag(3)
                            Text("Over $3000").tag(4)
                        }
                    }
                    Section(header: Text("Lease Start")) {
                        Picker(selection: $leaseStart, label: Text("Lease Term")) {
                            Text("Any").tag("any")
                            Text("SP 2023").tag("SP 2023")
                            Text("FA 2024").tag("FA 2024")
                            Text("SP 2024").tag("SP 2024")
                        }
                    }
                    Section(header: Text("Lease End")) {
                        Picker(selection: $leaseEnd, label: Text("Lease Term")) {
                            Text("Any").tag("any")
                            Text("SP 2023").tag("SP 2023")
                            Text("FA 2024").tag("FA 2024")
                            Text("SP 2024").tag("SP 2024")
                        }
                    }
                    Section(header: Text("Beds")) {
                        Picker(selection: $nRoom, label: Text("Rooms and Beds")) {
                            Text("any").tag(0)
                            Text("1 bedroom").tag(1)
                            Text("2 bedrooms").tag(2)
                            Text("3+ bedrooms").tag(3)
                        }
                    }
                    Section(header: Text("Baths")) {
                        Picker(selection: $nBath, label: Text("Baths")) {
                            Text("any").tag(0)
                            Text("1 bedroom").tag(1)
                            Text("2 bedrooms").tag(2)
                            Text("3+ bedrooms").tag(3)
                        }
                    }
                    Section(header: Text("Amenities")) {
                        ForEach(amenities.allCases, id:\.self){
                            amenity in
                            Toggle(amenity.rawValue, isOn: Binding<Bool>(
                                get: { self.filterAmenities.contains(amenity) },
                                set: { if $0 { self.filterAmenities.insert(amenity) } else { self.filterAmenities.remove(amenity) } }
                            ))
                        }
                    }
                    Section(header: Text("Features")) {
                        ForEach(features.allCases, id:\.self){
                            feature in
                            Toggle(feature.rawValue, isOn: Binding<Bool>(
                                get: { self.filterFeatures.contains(feature) },
                                set: { if $0 { self.filterFeatures.insert(feature) } else { self.filterFeatures.remove(feature) } }
                            ))
                        }
                    }
                    Section(header: Text("Safety")) {
                        ForEach(safety.allCases, id:\.self){
                            s in
                            Toggle(s.rawValue, isOn: Binding<Bool>(
                                get: { self.filterSafety.contains(s) },
                                set: { if $0 { self.filterSafety.insert(s) } else { self.filterSafety.remove(s) } }
                            ))
                        }
                    }
                    Section(header: Text("Building Type")) {
                        Picker(selection:$bType,label:Text("Building Type")){
                            Text("Any").tag(buildingType.any)
                            Text("Rental Unit").tag(buildingType.rentalUnits)
                            Text("House").tag(buildingType.House)
                            Text("Condo").tag(buildingType.Condos)
                        }
                    }
                    Section(header: Text("Pet Policy")) {
                        Picker(selection: $petPolciy,label:Text("Pet Policy")){
                            Text("Pets allowed").tag(true)
                            Text("Pets not allowed").tag(false)
                        }
                    }
                }
                .navigationBarTitle(Text("Filter"))
                .navigationBarItems(trailing: Button(action: {
                    showFilter.toggle()
                    manager.filterProperty = filterPlace(priceRange: priceRange, nRoom: nRoom,nBath: nBath, leaseStart: leaseStart, leaseEnd: leaseEnd, bType: bType, filterFeatures: Array(filterFeatures), filterSafety: Array(filterSafety), filterAmenities: Array(filterAmenities), petPolicy: petPolciy)
                }) {
                    Text("Done")
                })
            }
        }


    }
}

//struct filterView_Previews: PreviewProvider {
//    static var previews: some View {
//        filterView().environmentObject(MapManager())
//    }
//}
