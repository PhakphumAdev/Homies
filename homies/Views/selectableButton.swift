//
//  selectableButton.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/13/23.
//

import SwiftUI

struct selectableButton: View {
    @Binding var isSelected: Bool
    @State var color: Color
    @State var text: String
    var body: some View {
        ZStack{
            Capsule().frame(height:50).foregroundColor(isSelected ? color: .gray)
            Text(text).foregroundColor(.white)
        }
    }
}

struct selectableButton_Previews: PreviewProvider {
    static var previews: some View {
        selectableButton(isSelected: .constant(false), color: .blue, text: "dummy")
    }
}
