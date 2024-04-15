//
//  mainView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/11/23.
//

import SwiftUI

struct mainView: View {
    @EnvironmentObject var manager : MapManager
    var body: some View {
        TabView{
            browseView().tabItem{Label("Browse",systemImage: "house").environment(\.symbolVariants, .none)}
//            savedView().tabItem{Label("Saved",systemImage:"heart").environment(\.symbolVariants, .none)}
//            ChatView(destID: "4").tabItem{Label("Inbox",systemImage: "envelope").environment(\.symbolVariants, .none)}
            inboxView().tabItem{Label("Inbox",systemImage: "envelope").environment(\.symbolVariants, .none)}
            ProfileView().tabItem{Label("Profile",systemImage: "person").environment(\.symbolVariants, .none)}
            if(!manager.isSignedIn){
                signUpView().tabItem{Label("signup",systemImage: "person.badge.key").environment(\.symbolVariants, .none)}
            }
        }
    }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView().environmentObject(MapManager())
    }
}
