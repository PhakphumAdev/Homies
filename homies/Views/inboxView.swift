//
//  inboxView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/11/23.
//

import SwiftUI


struct inboxView: View {
    @EnvironmentObject var manager : MapManager
    @State private var showSheet = false
    @State var selectedUser : userInboxModel?
    var body: some View {
        if(manager.isSignedIn){
            VStack(alignment: .leading) {
                Text("Messages")
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                    .padding(.horizontal)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(manager.userInbox, id: \.self) { user in
                            Button(action: {
                                selectedUser = user
                                manager.destID = user.destID
                                showSheet.toggle()
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 48, height: 48)
                                    Text(user.displayName)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .background(Color.blue)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        manager.fetchCurrentUserInbox()
                        manager.getUserId()
                    }
                    .onDisappear {
                        manager.stopFetchCurrentUserInbox()
                    }.sheet(isPresented: $showSheet) {
                        ChatView(destID: selectedUser?.destID ?? "no dest id")
                        //                    ChatView(destID: "uWXYlsbsioQ9Du3lfnAqiWDkZ6F2")
                    }
                }
            }
            
        }
    }
}


//
//struct inboxView_Previews: PreviewProvider {
//    static var previews: some View {
//        inboxView().environmentObject(MapManager())
//    }
//}
