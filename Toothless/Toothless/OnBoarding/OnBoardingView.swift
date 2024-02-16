//
//  OnBoardingView.swift
//  Toothless
//
//  Created by Alessia Previdente on 16/02/24.
//


import Foundation
import SwiftUI
import SwiftData

struct CustomColor {
    static let background = Color("Background")
    static let red = Color("Red")
    static let text = Color("Text")
    static let brightred = Color("BrightRed")
    static let backgroundhome = Color("BackgroundHome")
}

struct OnBoardingView: View {
    var body: some View {
        NavigationStack{
            
            ZStack{
                CustomColor.background
                    .ignoresSafeArea()
                VStack(spacing: 80.0){
                    VStack(alignment: .center){
                        Text("Welcome to")
                            .font(.largeTitle)
                            .foregroundStyle(CustomColor.text)
                            .bold()
                        Text("BeBrave.")
                            .font(.largeTitle)
                            .foregroundStyle(CustomColor.red)
                            .bold()
                    }
                    VStack(spacing: 25){
                        InfoBoardingView(iconName: "map.fill", titleText: "Avoid dangerous situations", descriptionText: "A map will show all the safe sposts that you can reach.")
                        
                        InfoBoardingView(iconName: "bell.badge.fill", titleText: "Push-Notification system", descriptionText: "Automatic notifications will be sent in order to see whether you are in danger or not. ")
                        
                        InfoBoardingView(iconName: "phone.arrow.down.left.fill", titleText: "Fake calls", descriptionText: "Simulate calls with a friend or a relative to avoid unsafe situations.")
                        InfoBoardingView(iconName: "exclamationmark.bubble.fill", titleText: "Real time reports", descriptionText: "See on the map all the dangerous zone to avoid reported by other users.")
                        
                    }
                    
                    VStack(alignment: .center, spacing: 20.0){
                        NavigationLink(destination: HomeView()) {
                            Text("Continue")
                                .font(.title3)
                                .bold()
                                .frame(width:250, height:50)
                                .padding(.horizontal, 40)
                                .foregroundColor(.white)
                                .background(CustomColor.red)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                }
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
