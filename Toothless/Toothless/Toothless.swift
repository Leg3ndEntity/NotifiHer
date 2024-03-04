//
//  Toothless.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI

struct Toothless: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @ObservedObject var pushToTalkManager: PushToTalkManager
    @State var checkWelcomeScreen: Bool = false
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                CompleteTimer(pushToTalkManager: PushToTalkManager())
            } else {
                WelcomeView()
            }
        }.onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
        }
    }
}

//#Preview {
//    Toothless()
//}
