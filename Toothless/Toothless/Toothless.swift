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
    @EnvironmentObject var tokenManager: TokenManager
    
    var body: some View {
        VStack {
            Group {
                if checkWelcomeScreen {
                    
                    CompleteTimer().environmentObject(tokenManager)
                } else {
                    
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
