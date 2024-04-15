//
//  savedView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/11/23.
//

import SwiftUI

struct savedView: View {
    @EnvironmentObject var manager: MapManager
    var body: some View {
        VStack{
            Text("User Saved")
            ForEach(manager.nearbyRentalUnits, id:\.self){
                i in
                if(i.favorite){
                    Text("\(i.type.rawValue)")
                    Text("\(i.name)")
                    Text("\(i.price)")
                }
            }
        }
    }
}

struct savedView_Previews: PreviewProvider {
    static var previews: some View {
        savedView().environmentObject(MapManager())
    }
}
