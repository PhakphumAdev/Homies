//
//  filterPlaceModel.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/30/23.
//

import Foundation
struct filterPlace{
    var priceRange : Int
    var nRoom : Int
    var nBath : Int
    var leaseStart : String
    var leaseEnd : String
    var bType : buildingType
    var filterFeatures : [features]
    var filterSafety : [safety]
    var filterAmenities : [amenities]
    var petPolicy : Bool
}
