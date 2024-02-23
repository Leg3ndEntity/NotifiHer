//
//  Toothless.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI
import AVFoundation
import UIKit
import PushToTalk

struct Toothless: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isShowingMain: Bool = false
    @State var checkWelcomeScreen: Bool = false
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()

    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    Spacer()
                    PageView(page: page)
                    Spacer()
                    if page == pages.last {
                        Text("Get started")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                            .onTapGesture {
                                    isWelcomeScreenOver = true
                                    isShowingMain.toggle()
                                    print("ciao")
                                }
                    }
                        else {
                        Button("Next", action: incrementPage)
                            .buttonStyle(.borderedProminent)
                            .font(.title2)
                    }
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .red
            dotAppearance.pageIndicatorTintColor = .gray
            checkWelcomeScreen = isWelcomeScreenOver
        }
        .fullScreenCover(isPresented: $isShowingMain, content: {
            CompleteTimer()
        })
    }

    func incrementPage() {
        pageIndex += 1
    }

    func goToZero() {
        pageIndex = 0
    }
}

struct Toothless_Previews: PreviewProvider {
    static var previews: some View {
        Toothless()
    }
}

