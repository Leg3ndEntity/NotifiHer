//
//  InfoElement.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI

struct InfoElement: View {
    
    var iconName: String = ""
    var titleText: String = ""
    var descriptionText: String = ""
    
    var body: some View {
        
        HStack(spacing: 15.0){
            Image(systemName: iconName)
                .resizable()
                .foregroundColor(Color.red)
                .frame(width: 25.0, height: 25.0)
            VStack(alignment: .leading){
                Text(titleText)
                    .fontWeight(.bold)
                Text(descriptionText)
                    .fontWeight(.light)
            }
        }.frame(width: 305)
        
    }
}

#Preview {
    InfoElement(iconName: "map.fill", titleText: "Avoid dangerous situation", descriptionText: "A map will show all the safe spots that you can reach")
}
