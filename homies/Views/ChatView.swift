//
//  ChatView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/28/23.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var manager : MapManager
    @State private var textMessage = ""
    var destID : String
    var body: some View {
        if(manager.isSignedIn){
            VStack{
                ScrollViewReader { scrollViewReader in
                    ScrollView {
                        ForEach(0..<manager.messages.count, id: \.self) { i in
                            ChatMessageView(message: manager.messages[i])
                                .id(i)
                                .listRowSeparator(.hidden)
                                .padding(.vertical)
                        }
                        .onChange(of: manager.messages.count) { _ in
                            withAnimation(.easeInOut) {
                                scrollViewReader.scrollTo(manager.messages.count - 1)
                            }
                        }
                    }
                }
                ChatFooterView(textMessage: textMessage, destID: destID)
            }.onAppear {
//                print("userid and destid")
//                print(manager.userID)
//                print(manager.destID)
                manager.listen()
            }
            .onDisappear {
                manager.stopListen()
            }
        }
        else{
            Text("Please sign in first!")
        }
    }
}
//
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView().environmentObject(MapManager())
//    }
//}
