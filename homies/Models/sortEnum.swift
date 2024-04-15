//
//  sortEnum.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/16/23.
//

import Foundation
enum sorting : String , Identifiable , CaseIterable{
    case homiesPick,newest,recentlyupdated,leastexpensive,mostexpensive,largest,smallest,earliestmovein
    var id: RawValue {rawValue}
}
