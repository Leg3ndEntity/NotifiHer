//
//  OnBoardingView.swift
//  Toothless
//
//  Created by Alessia Previdente on 16/02/24.
//


import Foundation
import SwiftUI

struct CustomColor {
    static let background = Color("Background")
    static let red = Color("Red")
    static let text = Color("Text")
    static let brightred = Color("BrightRed")
    static let backgroundhome = Color("BackgroundHome")
}

struct OnBoardingView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isShowingMain: Bool = false
    var body: some View {
        
        VStack(alignment: .center, spacing: 110){
            VStack(spacing: 75.0) {
                Text("Welcome to \n nome app!")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 15.0) {
                    InfoElement(iconName: "map.fill", titleText: "Avoid dangerous situation", descriptionText: "A map will show all the safe spots that you can reach")
                    InfoElement(iconName: "bell.badge.fill", titleText: "Push-Notification system", descriptionText: "Automatic notifications will be sent in order to see whether you are in danger or not. ")
                    InfoElement(iconName: "phone.arrow.down.left.fill", titleText: "Fake calls", descriptionText: "Simulate calls with a friend or a relative to avoid unsafe situations.")
                    InfoElement(iconName: "exclamationmark.bubble.fill", titleText: "Real time reports", descriptionText: "See on the map all the dangerous zone to avoid reported by other users.")
                }
            }
            
            ZStack {
                Text("Continue")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width:320, height:50)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(15)
            }.onTapGesture {
                isWelcomeScreenOver = true
                isShowingMain.toggle()
                print("ciao")
            }
        } //fine Vstack
        .fullScreenCover(isPresented: $isShowingMain, content: {
            CompleteTimer()
        })
        
    }
}
#Preview {
    OnBoardingView()
}
