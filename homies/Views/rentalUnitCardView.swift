//
//  rentalUnitCardView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/28/23.
//

import SwiftUI

struct rentalUnitCardView: View {
    @EnvironmentObject var manager : MapManager
    var rentalUnit : Place?
    
    private var title : String {
        guard rentalUnit != nil else {return "unknown"}
        return rentalUnit!.name
    }
    
    private var bType : buildingType {
        guard rentalUnit != nil else {return .any}
        return rentalUnit!.type
    }
    
    private var price : Int {
        guard rentalUnit != nil else{return -1}
        return rentalUnit!.price
    }
    
    private var destID : String{
        guard rentalUnit != nil else{return ""}
        return rentalUnit!.userID
    }
    
    private var propertyID : String {
        guard rentalUnit != nil else {return ""}
        return rentalUnit!.ID.uuidString
    }
    
    private var unitAddress : String{
        guard rentalUnit != nil else {return ""}
        return rentalUnit!.address
    }
    @State private var showChat = false
    @State private var propertyImage = UIImage(systemName: "photo")!
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                manager.showPlace.toggle()
            }) {
                Label("", systemImage: "arrowtriangle.backward")
            }
            Image(uiImage: propertyImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(10)
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 8) {
                Text(bType.rawValue)
                    .font(.headline)
                Text(title)
                    .font(.title2)
                Text("Address:\(unitAddress)")
                Text("\(price)")
                    .font(.headline)
            }
            .padding(.horizontal)
            Button(action: {
                showChat.toggle()
            }) {
                Text("Contact")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showChat) {
                if destID != manager.userID {
                    ChatView(destID: destID)
                }
            }
        }
        .padding()
        .onAppear(){
            manager.getPropertyPicture(propertyID: propertyID){
                data in
                propertyImage = data
            }
        }
    }
}

//struct rentalUnitCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        rentalUnitCardView().environmentObject(MapManager())
//    }
//}
