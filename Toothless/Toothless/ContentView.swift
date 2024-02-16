//
//  ContentView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isActivated = false
    var body: some View {
        ZStack{
            if isActivated{
                CustomColor.backgroundhome
                    .ignoresSafeArea()
            }
            else{
                CustomColor.background
                    .ignoresSafeArea()
            }
        
            Circle()
                .foregroundColor(CustomColor.brightred)
                .opacity(0.3)
                .frame(width: isActivated ? 300 : 100)
            
            Button{
                withAnimation(.easeInOut(duration: 1)){
                        isActivated.toggle()
                    }
                }
        label:{
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .padding(.all, 40)
                    .background(isActivated ? .white : .white)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/).shadow(radius: 5)
            }
        }
        
    }
}

#Preview {
    HomeView()
}
