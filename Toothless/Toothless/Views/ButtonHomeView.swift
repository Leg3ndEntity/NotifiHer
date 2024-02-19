//
//  ButtonHomeView.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import SwiftUI

struct ButtonHomeView: View {
    private var iconName: String = ""
    private var nameFeature: String = ""
    
    init(iconName: String, nameFeature: String) {
        self.iconName = iconName
        self.nameFeature = nameFeature
    }
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                     .frame(width:60,height: 60)
                     .foregroundColor(CustomColor.background)
                Image(systemName: iconName)
                    .resizable()
                    .foregroundStyle(CustomColor.red)
                    .frame(width:25, height:25)
            }
            Text(nameFeature)
                .font(.footnote)
                .bold()
                .foregroundStyle(CustomColor.text)
        }
    }
}

#Preview {
    ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature:"Fake Calls")
}
