//
//  ContentView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/8/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct ContentView: View {
    @AppStorage("isSignedIn") var isSignedIn = false
    @EnvironmentObject var manager : MapManager
    @State private var showingMainView = false
    @State private var showingsignUpView = false
    @State var completesignUp = false
    var body: some View {
        if(manager.isSignedIn){
            mainView()
        }
        else if(!showingMainView && !showingsignUpView){
            VStack{
            Image("priscilla-du-preez-XkKCui44iM0-unsplash").resizable().scaledToFill().offset(y:-60)
            Text("Find your perfect").font(.system(size:36)).offset(x:-40,y:-60)
            (Text("Homies").bold()+Text(" with us")).font(.system(size:36)).offset(x:-50,y:-60)
            Button(action:{showingsignUpView=true}){
                Text("Get Started For Free").foregroundColor(Color(red:0.21,green:0.13,blue:0.39))
            }.buttonStyle(.borderedProminent).tint(Color(red:0.87,green:0.90,blue:0.28))
            Button(action:{showingMainView=true}){
                Text("Continue as Guest").foregroundColor(Color(red:0.21,green:0.13,blue:0.39))
            }.buttonStyle(.borderedProminent).tint(Color(red:0.96,green:0.96,blue:0.94))
        }
    }
        else if((!showingMainView && showingsignUpView)){
            signUpView()
        }
        else if(showingMainView && !showingsignUpView){
            mainView()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

