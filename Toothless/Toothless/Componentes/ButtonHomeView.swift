//
//  ButtonHomeView.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import SwiftUI

struct ButtonHomeView: View {
     var iconName: String = ""
     var nameFeature: String = ""
    
    
    @Binding var showModal: Bool
    
    var body: some View {
        VStack{
            ZStack{
                Circle().shadow(radius: 2)
                     .frame(width:60,height: 60)
                     .foregroundColor(CustomColor.background)
                Image(systemName: iconName)
                    .resizable()
                    .foregroundStyle(CustomColor.customred)
                    .frame(width:25, height:25)
                    
            }
            Text(nameFeature)
                .font(.footnote)
                .bold()
                .foregroundStyle(CustomColor.text)
        }.onTapGesture {
            showModal.toggle()
        }
    }
}

//#Preview {
//    ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature:"Fake Calls")
//}
