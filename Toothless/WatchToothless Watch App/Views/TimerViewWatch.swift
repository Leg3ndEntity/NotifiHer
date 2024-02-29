//
//  TimerViewWatch.swift
//  Toothless
//
//  Created by Simone Sarnataro on 22/02/24.
//

import SwiftUI
import WatchKit

struct TimerViewWatch: View {
    @State var buttonTapped: Bool = false
    @State var isActivated: Bool = false
    @State var isPressed: Bool = false
    
    @State var showMark: Bool = true
    @State var showAlert = false
    @State var showCircle = false
    @State var circleOpacity = false
    
    func TapAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                self.buttonTapped = false
            }
        }
    }
    
    func CircleAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showCircle.toggle()
                CircleAnimation()
            }
        }
    }
    
    func ShowAlert(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showAlert = true
        }
    }
    
    var body: some View {
        ZStack {
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
                
                withAnimation(.easeIn){
                    if !isActivated{
                        Text("Hold to activate")
                            .fontWeight(.bold)
                            .offset(x: 0, y: 75)
                    }else{
                        Text("Hold to deactivate")
                            .fontWeight(.bold)
                            .offset(x: 0, y: 75)
                    }
                }
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .opacity(circleOpacity ? 0 : 0.3)
                        .frame(width: showCircle ? 160 : 120)
                    Circle()
                        .foregroundColor(.white)
                        .opacity(circleOpacity ? 0 : 0.3)
                        .frame(width: showCircle ? 140: 120)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120)
                        .shadow(radius: 7)
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.red)
                        .opacity(withAnimation{showMark ? 1 : 0})
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                }.padding(.bottom, 40)
                    .onLongPressGesture(minimumDuration: 1.5){
                        print("notifica")
                        if !isActivated{
                            ShowAlert()
                            buttonTapped = true
                            TapAnimation()
                            withAnimation{
                                CircleAnimation()
                                isActivated = true
                                showMark = true
                            }
                        }else{
                            isActivated = false
                            circleOpacity = true
                        }
                    }
            }.ignoresSafeArea()
        } .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you ok?"),
                message: Text("If you don’t dismiss this notification, a default message will be sent to your emergency contact"),
                dismissButton: .default(
                    Text("DISMISS"),
                    action: {
                        showAlert = false
                    }
                )
            )
        }//fine alert
    }
}

#Preview {
    TimerViewWatch()
}
