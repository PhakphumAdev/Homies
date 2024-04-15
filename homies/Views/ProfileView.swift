//
//  ProfileView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/11/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var manager : MapManager
    @State private var userName = ""
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var showCreateRentalUnit = false
    var body: some View {
        if(manager.isSignedIn){
            VStack(spacing: 20) {
                VStack {
                    Image(uiImage: manager.userProfileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                    
                    Button("Upload Profile Picture") {
                        showSheet = true
                    }
                    .foregroundColor(.blue)
                    .font(.subheadline)
                }
                
                Divider()
                
                VStack(spacing: 20) {
                    TextField("Username", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Update Username") {
                        manager.updateDisplayName(displayName: userName)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    Button("Get User Profile") {
                        manager.getUserId()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                
                Divider()
                
                Button("Create Rental Unit") {
                    showCreateRentalUnit.toggle()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button("Sign Out") {
                    manager.signOut()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)
                //            Button("fetch property"){
                //                manager.fetchProperties()
                //                print(manager.nearbyRentalUnits)
                //            }
            }
            .sheet(isPresented: $showSheet) {
                ImagePicker(selectedImage: self.$image,uploadPath: "users/\(manager.userID)/images/profilepicture")
            }
            .sheet(isPresented: $showCreateRentalUnit){
                createRentalUnitView()
            }
            .onAppear {
                manager.getUserProfilePicture()
                manager.userDisplayName = manager.getUserDisplayName()
                userName = manager.userDisplayName
            }
            .padding()
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(MapManager())
    }
}
