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
        ZStack{
            if let gif = page.gif {
                GifImage(gif)
            }
            if let image = page.image{
                Image(image)
            }
            VStack{
                Text(page.name ?? "")
                    .foregroundStyle(.black)
                    .font(.title)
                    .bold()
                    .frame(width: 340)

                Text(page.description ?? "")
                    .foregroundStyle(.black)
                    .font(.title3)
                    .frame(width: 340)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }.padding(.top, 400)
        }.ignoresSafeArea()
    }
}
