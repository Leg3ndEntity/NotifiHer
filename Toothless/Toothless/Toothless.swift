//
//  Toothless.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI

struct Toothless: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    @State private var currentViewShowing: String = "login"
    
    var body: some View {
        VStack {
            Group {
                if checkWelcomeScreen {
                    // If the welcome screen is not over, show the authentication views
                        CompleteTimer()
                } else {
                    // If the welcome screen is over, show a different view (e.g., your main app content)
                    if(currentViewShowing == "login") {
                        LoginView(currentShowingView: $currentViewShowing)
                    } else {
                        SignupView(currentShowingView: $currentViewShowing)
                    }
                }
            }
            ////            if checkWelcomeScreen {
            ////                CompleteTimer()
            ////            } else {
            ////                WelcomeView()
            ////            }
            //            if(currentViewShowing == "login") {
            //                LoginView(currentShowingView: $currentViewShowing)
            //                    .preferredColorScheme(.light)
            //            } else {
            //                SignupView(currentShowingView: $currentViewShowing)
            //                    .preferredColorScheme(.dark)
            //                    .transition(.move(edge: .bottom))
            //            }
        }.onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
        }
    }
}

#Preview {
    Toothless()
}
