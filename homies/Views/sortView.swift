//
//  sortView.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/16/23.
//

import SwiftUI

struct sortView: View {
    @EnvironmentObject var manager : MapManager
    @State private var showSorting = false
    var body: some View {
        VStack{
            Button(action:{showSorting.toggle()}){
                Image(systemName: "slider.horizontal.3")
                Text(manager.sortingType.rawValue)
            }
        }.sheet(isPresented: $showSorting) {
            ForEach(sorting.allCases, id:\.self){
                i in
                if(manager.sortingType==i){
                    Button(action:{manager.sortingType=i}){
                        Text(i.rawValue).foregroundColor(Color(red:0.21,green:0.13,blue:0.39))
                    }.buttonStyle(.borderedProminent).tint(Color(red:0.87,green:0.90,blue:0.28))
                }
                else{
                    Button(action:{manager.sortingType=i}){
                        Text(i.rawValue).foregroundColor(Color(red:0.21,green:0.13,blue:0.39))
                    }.buttonStyle(.borderedProminent).tint(Color(.white))
                }
            }
        }
    }
}

struct sortView_Previews: PreviewProvider {
    static var previews: some View {
        sortView().environmentObject(MapManager())
    }
}
