//
//  buildingFeatures+Amenities.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/15/23.
//

import Foundation

enum amenities : String, Identifiable, CaseIterable, Codable{
    case washerdryer,dishwasher,furnished,wifi,fireplace,kitchen,heating,tv,airconditioning,storageavaliable,privateoutdoorspace
    var id: RawValue {rawValue}
    }

enum features : String, Identifiable, CaseIterable, Codable{
    case laundryroom,parking,gym,publicoutdoorspace,elevator,pool,smokefree
    var id: RawValue {rawValue}
}

enum safety : String, Identifiable, CaseIterable, Codable{
    case smokealarm,carbonmonoxidealarm
    var id: RawValue{rawValue}
}
