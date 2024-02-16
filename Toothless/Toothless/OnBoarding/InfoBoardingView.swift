//
//  InfoBoardingView.swift
//  Toothless
//
//  Created by Alessia Previdente on 16/02/24.
//

import SwiftUI
import SwiftData

struct InfoBoardingView: View {
    private var iconName: String = ""
    private var titleText: String = ""
    private var descriptionText: String = ""
    
    init(iconName: String, titleText: String, descriptionText: String) {
        self.iconName = iconName
        self.titleText = titleText
        self.descriptionText = descriptionText
    }
    
    var body: some View {
        HStack(spacing: 20.0){
            Image(systemName: iconName)
                .resizable()
                .frame(minWidth: 19, idealWidth: 28, maxWidth: 30, minHeight: 19, idealHeight: 28, maxHeight: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(CustomColor.red)
            VStack(alignment: .leading){
                Text(titleText)
                    .foregroundStyle(CustomColor.text)
                    .font(.headline)
                    .bold()
                Text(descriptionText)
                    .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.text)
                    .opacity(0.5)
            }
        }
        .padding(.horizontal)
    }
}


#Preview{
    InfoBoardingView(iconName: "map.fill", titleText: "Avoid dangerous situations", descriptionText: "A map will show all the safe sposts that you can reach.")
}
