//
//  CompleteTimer.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI
import UserNotifications

struct CompleteTimer: View {
    @State var buttonTapped: Bool = false
    @State var isActivated: Bool = false
    @State var isPressed: Bool = false
    
    @State var showSeiSicuro: Bool = false
    @State var startedAnimation: Bool = false
    @State var showCancel = false
    @State var showCircle = false
    @State var circleOpacity = false
    @State var showMark: Bool = true
    @State var showAlert = false
    @State var textSwap = true
    
    @State var start = false
    @State var to : CGFloat = 0
    @State var count = 300
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var dismissTimer: Timer?
    
    @Environment(\.colorScheme) var colorScheme
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
    
    
    func Notify(){
        let content = UNMutableNotificationContent()
        content.title = "Are you ok?"
        content.body = "If you don’t dismiss this notification, a default message will be sent to your emergency contact"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    
    func TapAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation{
                self.buttonTapped = false
            }
        }
    }
    
    func SwapText(){
        if textSwap{
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    textSwap.toggle()
                    SwapText()
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    textSwap.toggle()
                    SwapText()
                }
            }
        }
    }
    
    func CircleAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                if isActivated{
                    showCircle.toggle()
                    CircleAnimation()
                }else{
                    print("fanculo")
                }
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
                ZStack {
                    if !isActivated{
                        CustomColor.background
                    }else{
                        withAnimation {
                            Color(CustomColor.customred)
                        }
                    }
                    
                    if !isActivated{
                        if textSwap{
                            Text("Tap to send an alert")
                                .font(.title3)
                                .fontWeight(.bold)
                                .offset(x: 0, y: -150)
                        }else{
                            Text("Hold to start the timer")
                                .font(.title3)
                                .fontWeight(.bold)
                                .offset(x: 0, y: -150)
                        }
                    }
                    if !showSeiSicuro{
                        Text("Are you sure?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .offset(x: 0, y: -150)
                    }
                    
                    
                    if isPressed {
                        RingView(percentage: 1, backgroundColor: Color.white.opacity(0), startColor: .white, endColor: .white, thickness: 37)
                            .scaleEffect(0.671)
                    }
                    //bottone
                    ZStack {
                        if startedAnimation{
                            Circle()
                                .foregroundColor(.white)
                                .opacity(circleOpacity ? 0.3 : 0)
                                .frame(width: showCircle ? 270 : 170)
                            Circle()
                                .foregroundColor(.white)
                                .opacity(circleOpacity ? 0.3 : 0)
                                .frame(width: showCircle ? 220: 170)
                        }
                        if !isActivated {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 170, height: 170)
                                .shadow(color: colorScheme == .dark ? .white : .gray, radius: colorScheme == .dark ? 6 : 4)
                        }else{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 170, height: 170)
                                .shadow(radius: 7)
                                .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                        }
                        
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 75, height: 70)
                            .foregroundColor(Color.red)
                            .opacity(showMark ? 1 : 0)
                            .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                    }//fine bottone
                    .onTapGesture {
                        if !isActivated{
                            //ShowAlert()
                            startedAnimation = true
                            buttonTapped = true
                            TapAnimation()
                            withAnimation{
                                CircleAnimation()
                                isActivated = true
                                circleOpacity = true
                                showCancel = true
                            }
                        }
                        if start{
                            restart()
                            isActivated = false
                            showMark = true
                            start = false
                            isPressed = false
                        }
                    }//fine onTapGesture
                    .onLongPressGesture(minimumDuration: 0.1) {
                        // Check if the timer has started before starting a new timer
                        if !isActivated && !start {
                            withAnimation {
                                isPressed = true
                                showMark = false
                                timerStart()
                                isActivated.toggle()
                            }
                        }
                    }//fine onLongPressGesture
                }//fine 1° Zstack
                
                ZStack {
                    Rectangle()
                        .frame(width: 110, height: 40)
                        .cornerRadius(30)
                        .foregroundColor(.white.opacity(0.2))
                    HStack{
                        Text("X")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("CANCEL")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }.foregroundColor(.white)
                }
                .padding(.bottom, 630)
                .padding(.leading, 240)
                .opacity(showCancel ? 1 : 0)
                .onTapGesture {
                    if isActivated{
                        startedAnimation = false
                        isActivated = false
                        circleOpacity = false
                        showCancel = false
                    }
                }
                Circle()
                    .trim(from: 0, to: self.to)
                    .stroke(Color.white.opacity(start ? 1 : 0), style: StrokeStyle(lineWidth: 25, lineCap: .round))
                    .frame(width: 214.5, height: 214.5)
                    .rotationEffect(rotationAngle)
                    .onReceive(self.time) { _ in
                        self.to = CGFloat(self.count) / 300
                    }
                Text("\(formattedTime)")
                    .foregroundStyle(Color("Timer"))
                    .font(.system(size: 65))
                    .fontWeight(.bold)
                    .onTapGesture {
                        // Check if the timer has started before deactivating
                        if isActivated && start {
                            withAnimation {
                                showMark = true
                                isPressed = false
                                start = false
                                isActivated.toggle()
                            }
                            restart()
                        }
                    }
                    .opacity(withAnimation{
                        start ? 1 : 0
                    })
            }//fine 2° Zstack
            .ignoresSafeArea()
        }//fine 3° Zstack
        .bottomSheet(presentationDetents: [.height(190), .height(80)], isPresented: .constant(true), sheetCornerRadius: 20) {
            ScrollView(.vertical, showsIndicators: false) {
                ModalView(showAlert: $showAlert, start: $start, count: $count, to: $to)
            }
        } onDismiss: {}
            .onAppear(perform: {
                SwapText()
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
                }
            })
            .onReceive(self.time) { (_) in
                if self.start{
                    if self.count > 0 {
                        self.count -= 1
                        print("\(count)")
                    }
                    else{
                        self.start.toggle()
                        self.Notify()
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
    CompleteTimer()
}
