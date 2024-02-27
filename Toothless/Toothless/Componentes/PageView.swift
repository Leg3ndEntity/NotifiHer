//
//  PageView.swift
//  Toothless
//
//  Created by Andrea Romano on 22/02/24.
//

import SwiftUI

struct PageView: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                GifImage(page.gif)
                    .cornerRadius(20)
                    .frame(width: 340, height: 310)
                    .padding(.bottom, 50)
                Spacer()
            }
            
            Text(page.name)
                .font(.title)
                .bold()
                .frame(width: 340)
            
            Text(page.description)
                .font(.title3)
                .padding(.horizontal)
        }
    }
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView(page: Page.samplePage)
//    }
//}

