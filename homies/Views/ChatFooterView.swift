//
//  ChatView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/28/23.
//

import SwiftUI

struct ChatFooterView: View {
    @EnvironmentObject var manager : MapManager
    @State var textMessage : String
    var destID : String
    var body: some View {
        Group {
            if(manager.messages.count==0){
                HStack {
                    Button(action: {
                        textMessage = "Is this unit still available?"
                    }, label: {
                        Text("Is this unit still available?")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        textMessage = "Can I have a room tour?"
                    }, label: {
                        Text("Can I have a room tour?")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        textMessage = "Are you allow pet?"
                    }, label: {
                        Text("Are you allow pet?")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                }
            }
            HStack {
                TextField("Say something...", text: $textMessage)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                
                Button(action: {
                    manager.sendMessage(newMessageText: textMessage, userDest: destID)
                    textMessage = ""
                }) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 30.0))
                }
                .disabled(textMessage.isEmpty)
                .foregroundColor(textMessage.isEmpty ? .gray : .blue)
            }
            .padding(.horizontal)
        }
        .background(Color("FirebaseGray"))

    }
}

//struct ChatFooterView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView().environmentObject(MapManager())
//    }
//}
