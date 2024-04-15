//
//  buildingType.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/15/23.
//

import Foundation
enum buildingType: String, Identifiable, CaseIterable{
    
    case any,rentalUnits,House,Condos
    var id : RawValue {rawValue}
    
}
