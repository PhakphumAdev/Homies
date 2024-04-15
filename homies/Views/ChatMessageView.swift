//
//  ChatMessageView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/29/23.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageView: View {
    @EnvironmentObject var manager : MapManager
    var message : Chat?
    
    private var sentMessage : String{
        guard message != nil else {return "noMessage"}
        return message!.text!
    }
    let currentUserName = Auth.auth().currentUser?.displayName
    var body: some View {
        HStack {
          if (message?.displayName != nil) {
              Text("\(message!.displayName!):")
          } else {
            Image(systemName: "person.crop.circle")
              .font(.system(size: 45.0))
          }
            Text("\(sentMessage)")
        }
    }
}
//
//struct ChatMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatMessageView().environmentObject(MapManager())
//    }
//}
