//
//  firebasePlace.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/29/23.
//

import Foundation
struct firebasePlace : Codable,Identifiable{
    var latitude: Double
    var longitude: Double
    var customName : String
    var id: UUID
    var photoUrl : String
    var price : Int
    var numBed: Int
    var numBath: Int
    var type : String
    var petPolicy : Bool
    var amenities : [String]
    var features : [String]
    var safety: [String]
    var leaseStart : String
    var leaseEnd : String
    var userID : String
    var address : String
}
