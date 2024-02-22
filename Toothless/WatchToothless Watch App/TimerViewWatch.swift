//
//  TimerViewWatch.swift
//  Toothless
//
//  Created by Simone Sarnataro on 22/02/24.
//

import SwiftUI

struct TimerViewWatch: View {
    @State var buttonTapped: Bool = false
    @State var isActivated: Bool = false
    @State var showMark: Bool = true
    
    func TapAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                self.buttonTapped = false
            }
        }
    }
    
    var body: some View {
        ZStack {
            if isActivated{
                withAnimation {
                    Color(.red)
                }
            }else{
                withAnimation {
                    Color(.black)
                }
            }
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 120, height: 120)
                    .shadow(radius: 7)
                    .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("Triangle"))
                    .opacity(withAnimation{buttonTapped ? 0.2 : 1})
            }.onTapGesture {
                print("notifica")
                if isActivated{
                    withAnimation{
                        showMark = true
                    }
                }else{
                    buttonTapped = true
                    TapAnimation()
                    withAnimation{
                        isActivated = true
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    TimerViewWatch()
}
