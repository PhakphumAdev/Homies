//
//  browseView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/11/23.
//

import SwiftUI

struct browseView: View {
    @State private var givenPlace: String = ""
    @State private var leaseStart: String = "any"
    @State private var leaseEnd: String = "any"
    @State private var showingMapView = false
    @State private var showingListView = false
    @State private var bedRooms : [Bool] = [false,false,false,false]
    @EnvironmentObject var manager : MapManager

    var body: some View {
        if(!showingMapView && !showingListView){
            VStack{
                Text("Welcome, \(manager.userDisplayName)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    TextField("Enter your neighborhood", text: $givenPlace)
                        .font(.title2)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                HStack(spacing: 20){
                    VStack{
                        Text("Lease Start")
                            .font(.headline)
                            .fontWeight(.bold)
                        Picker(selection: $leaseStart, label: Text("Lease Term")) {
                            Text("Any").tag("any")
                            Text("SP 2023").tag("SP 2023")
                            Text("FA 2024").tag("FA 2024")
                            Text("SP 2024").tag("SP 2024")
                        }
                    }
                    VStack{
                        Text("Lease end")
                            .font(.headline)
                            .fontWeight(.bold)
                        Picker(selection: $leaseEnd, label: Text("Lease Term")) {
                            Text("Any").tag("any")
                            Text("SP 2023").tag("SP 2023")
                            Text("FA 2024").tag("FA 2024")
                            Text("SP 2024").tag("SP 2024")
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                VStack {
                    Text("Bedrooms")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    HStack(spacing: 20) {
                        ForEach(0...3,id:\.self){ i in
                            selectableButton(isSelected: $bedRooms[i], color: .blue, text: "\(i)").onTapGesture {
                                bedRooms[i].toggle()
                                if(bedRooms[0] && i != 0){
                                    bedRooms[0] = false
                                }
                                if(bedRooms[1] && i != 1){
                                    bedRooms[1] = false
                                }
                                if(bedRooms[2] && i != 2){
                                    bedRooms[2] = false
                                }
                                if(bedRooms[3] && i != 3){
                                    bedRooms[3] = false
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                Button(action:{
                    showingMapView.toggle()
                    manager.address = givenPlace
                    var nRoom = 0
                    if(bedRooms[1]==true){
                        nRoom = 1
                    }
                    if(bedRooms[2]==true){
                        nRoom = 2
                    }
                    if(bedRooms[3]==true){
                        nRoom = 3
                    }
                    manager.filterProperty = filterPlace(priceRange: 0, nRoom: nRoom, nBath: 0, leaseStart: leaseStart, leaseEnd: leaseEnd, bType: buildingType.any, filterFeatures: [], filterSafety: [], filterAmenities: [], petPolicy: false)
                    manager.searchSetMapRegion()
                }){
                    Text("See \(manager.nearbyRentalUnits.count) Rentals")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color(red:0.87,green:0.90,blue:0.28))
                        .foregroundColor(Color(red:0.21,green:0.13,blue:0.39))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 40)
                Spacer()
            }.onAppear(){
                manager.userDisplayName = manager.getUserDisplayName()
            }
            .padding(.horizontal, 20)
        }
        else if(showingMapView && !showingListView){
            VStack {
                HStack {
                    Button(action: {
                        showingMapView = false
                        showingListView = false
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                    Text("\(givenPlace)")
                        .font(.headline)
                        .padding(.horizontal)
                    filterView()
                        .padding(.trailing)
                }
                HStack {
                    Button(action: {
                        showingListView = true
                        showingMapView = false
                    }) {
                        Label("List", systemImage: "list.bullet")
                    }
                    Spacer()
                    Button(action: {
                        showingMapView = true
                        showingListView = false
                    }) {
                        Label("Map", systemImage: "map")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                ScrollView {
                    UIMap(manager: manager)
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                }
                ZStack {
                    if(manager.showPlace) {
                        rentalUnitCardView(rentalUnit: manager.selectedPlace)
                            .onDisappear(){
                                manager.showPlace = false
                            }
                    }
                }
            }

        }
        else if(!showingMapView && showingListView){
            NavigationView {
                VStack {
                    HStack {
                        Button(action: {
                            showingMapView = true
                            showingListView = false
                        }) {
                            Image(systemName: "chevron.backward")
                        }
                        Text("\(givenPlace)")
                            .font(.headline)
                        Spacer()
                        filterView()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            showingListView = false
                            showingMapView = true
                        }) {
                            Image(systemName: "map.fill")
                                .font(.title2)
                        }
                        Spacer()
                        sortView()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    List(manager.nearbyRentalUnits, id: \.self) { i in
                        if manager.showornoshow(rentalUnit: i) {
                            rentalUnitCardView(rentalUnit: i)
                        }
                    }
                    .listStyle(.plain)
                    .navigationBarHidden(true)
                }
            }
            .ignoresSafeArea()

        }
    }
}

struct browseView_Previews: PreviewProvider {
    static var previews: some View {
        browseView().environmentObject(MapManager())
    }
}
