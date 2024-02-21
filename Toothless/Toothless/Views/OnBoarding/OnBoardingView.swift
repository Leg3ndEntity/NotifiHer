//
//  OnBoardingView.swift
//  Toothless
//
//  Created by Alessia Previdente on 16/02/24.
//


import SwiftUI

struct CustomColor {
    static let background = Color("Background")
    static let customred = Color("CustomRed")
    static let text = Color("Text")
    static let brightred = Color("BrightRed")
    static let backgroundhome = Color("BackgroundHome")
}

struct OnBoardingView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isShowingMain: Bool = false
    var body: some View {
        
        VStack(alignment: .center, spacing: 60){
            VStack(spacing: 75.0) {
                Text("Welcome to \n nome app!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 17.0) {
                        Image(systemName: "map.fill").accessibilityHidden(true)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .foregroundStyle(.red)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text("Avoid dangerous situations")
                                .fontWeight(.bold)
                            
                            Text("A map will show all the safe spots that you can reach.")
                                .fontWeight(.light)
                        }
                    }.padding(.horizontal)
                        .padding(.bottom, 25)
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 17.0) {
                            Image(systemName: "bell.badge.fill").accessibilityHidden(true)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .bold()
                                .foregroundStyle(.red)
                                .frame(width: 30)
                            
                            
                            VStack(alignment: .leading) {
                                Text("Push-Notification System")
                                    .fontWeight(.bold)
                                
                                Text("Automatic notifications will be sent in order to see whether you are in danger or not.")
                                    .fontWeight(.light)
                            }
                        }.padding(.horizontal)
                            .padding(.bottom, 25)
                    }
                    
                    HStack(spacing: 15.0) {
                        VStack {
                            Image(systemName: "phone.arrow.down.left.fill").accessibilityHidden(true)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .bold()
                                .foregroundStyle(.red)
                                .frame(width: 29)
                            
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Fake calls")
                                .fontWeight(.bold)
                            
                            
                            Text("Simulate calls with a friend or a relative to avoid unsafe situations.")
                                .fontWeight(.light)
                            
                        }
                        
                    }
                    .padding(.horizontal, 18.0)
                    .padding(.bottom, 25)
                    
                    HStack(spacing: 15.0) {
                        VStack {
                            Image(systemName: "exclamationmark.bubble.fill").accessibilityHidden(true)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .bold()
                                .foregroundStyle(.red)
                                .frame(width: 29)
                            
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Real Time Reports")
                                .fontWeight(.bold)
                            
                            
                            Text("See on the map all the dangerous zone to avoid reported by other users.")
                                .fontWeight(.light)
                            
                        }
                        
                    }.padding(.horizontal, 18.0)
                        .padding(.bottom)
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
        }.frame(width: 350)
        .fullScreenCover(isPresented: $isShowingMain, content: {
            CompleteTimer()
        })
        
    }
}
#Preview {
    OnBoardingView()
}
