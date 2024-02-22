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
    @State var checkWelcomeScreen: Bool = false
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                CompleteTimer()
            } else {
                OnBoardingView()
            }
        }.onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
        }
    }
}

#Preview {
    Toothless()
}
