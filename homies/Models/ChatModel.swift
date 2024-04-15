//
//  ChatModel.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/28/23.
//

import Foundation
struct Chat : Identifiable, Codable{
    var id : String
//    var destID : String
    let text : String?
    let displayName : String?
    let imageUrl : String?
}

struct chatUserData : Identifiable, Codable{
    var id : String
    var chatHistory : [Chat]
}
