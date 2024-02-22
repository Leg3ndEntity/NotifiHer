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
    @State var isPressed: Bool = false
    
    @State var showMark: Bool = true
    @State var showAlert = false
    @State var showCircle = false
    
    @State var start = false
    @State var to : CGFloat = 0
    @State var count = 5
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var dismissTimer: Timer?
    
    var changeFunction: (() -> Void)?
    var formattedTime: String {
        let minutes = count / 60
        let seconds = count % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    var rotationAngle: Angle {
        let progress = 1 - to
        return .degrees(Double(progress) * 360 - 90)
    }
    
    func restart(){
        start = false
        self.count = 300
        self.to = 0
        print("restart")
    }
    func timerStart(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            isPressed = false
            if isActivated{
                if self.count == 0 {
                    self.count = 300 // Riporta il timer a 5 minuti
                    withAnimation(.default){
                        self.to = 0
                    }
                }
                self.start.toggle()
                print("start")
            }
        }
    }
    func timerRestart(){
        if self.count == 0 {
            self.count = 300 // Riporta il timer a 5 minuti
            withAnimation(.default){
                self.to = 0
            }
        }
        self.start.toggle()
        print("start")
    }
    
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
                
                if isPressed {
                    RingView(percentage: 1, backgroundColor: Color.white.opacity(0), startColor: .white, endColor: .white, thickness: 20)
                        .scaleEffect(0.9)
                }
                
                ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .opacity(0.3)
                            .frame(width: showCircle ? 160 : 120)
                        Circle()
                            .foregroundColor(.white)
                            .opacity(0.3)
                            .frame(width: showCircle ? 140: 120)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120)
                        .shadow(radius: 7)
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("Triangle"))
                        .opacity(withAnimation{showMark ? 1 : 0})
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                }.onTapGesture {
                    print("notifica")
                    if !isActivated{
                        buttonTapped = true
                        TapAnimation()
                        withAnimation{
                            CircleAnimation()
                            isActivated = true
                            showMark = true
                        }
                    }
                }
                .onLongPressGesture(minimumDuration: 0.1){
                    if isActivated{
                        print("yuri")
                    }
                    else{
                        withAnimation {
                            isPressed = true
                            showMark = false
                            timerStart()
                            isActivated.toggle()
                        }
                    }
                }
                Circle()
                    .trim(from: 0, to: self.to)
                    .stroke(Color.white.opacity(start ? 1 : 0), style: StrokeStyle(lineWidth: 18.6, lineCap: .round))
                    .frame(width: 149, height: 149)
                    .rotationEffect(rotationAngle)
                    .onReceive(self.time) { _ in
                        self.to = CGFloat(self.count) / 300
                    }
                Text("\(formattedTime)")
                    .foregroundStyle(Color("Timer"))
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                    .opacity(withAnimation{
                        start ? 1 : 0
                    })
            }.ignoresSafeArea()
        } .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you ok?"),
                message: Text("If you don’t dismiss this notification, a default message will be sent to your emergency contact"),
                dismissButton: .default(
                    Text("DISMISS"),
                    action: {
                        timerRestart()
                        self.dismissTimer?.invalidate()
                        showAlert = false
                    }
                )
            )
        }//fine alert
        .onReceive(self.time) { (_) in
            if self.start{
                if self.count > 0 {
                    self.count -= 1
                    print("\(count)")
                }
                else{
                    self.start.toggle()
                    self.showAlert = true
                    self.dismissTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                        if showAlert{
                            print("Popup alert ignored for 10 seconds")
                            self.showAlert = false
                            restart()
                            isActivated.toggle()
                            showMark = true
                        }
                    }
                }
            }
        }//fine onReceive
    }
}

#Preview {
    TimerViewWatch()
}
