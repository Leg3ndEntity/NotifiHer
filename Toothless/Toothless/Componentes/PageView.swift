//
//  PageView.swift
//  Toothless
//
//  Created by Andrea Romano on 22/02/24.
//

import SwiftUI

struct PageView: View {
    private let pages: [Page] = Page.samplePages
    var page: Page
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                if let gif = page.gif {
                    GifImage(gif)
                        .cornerRadius(20)
                        .frame(width: 340, height: 310)
                        .padding(.bottom, 50)
                }
                Spacer()
            }
            
            Text(page.name ?? "")
                .font(.title)
                .bold()
                .frame(width: 340)
            
            Text(page.description ?? "")
                .font(.title3)
                .padding(.horizontal)
        }
    }
}
