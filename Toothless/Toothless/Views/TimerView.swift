//
//  CompleteTimer.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI
import UserNotifications
import MessageUI

struct CompleteTimer: View {
    @State var isActivated: Bool = false
    @State var isPressed: Bool = false
    @State var showCircle: Bool = false
    @State var showMark: Bool = true
    @State var prova: Bool = false
    
    @State var pollo = false
    @State var start = false
    @State var to : CGFloat = 0
    @State var showAlert = false
    @State var count = 300
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
    
    func sendMessage() {
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.recipients = ["3458472293"]
            composeVC.body = "Questo è un messaggio di emergenza."
            
            composeVC.messageComposeDelegate = nil
            
            UIApplication.shared.windows.first?.rootViewController?.present(composeVC, animated: false, completion: nil)
        } else {
            print("Il dispositivo non può inviare messaggi.")
        }
    }
    
    func Notify(){
        let content = UNMutableNotificationContent()
        content.title = "Are you ok?"
        content.body = "If you don’t dismiss this notification, a default message will be sent to your emergency contact"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    func restart(){
        start = false
        self.count = 300
        self.to = 0
        print("restart")
        pollo=false
    }
    
    func timerStart(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            isPressed = false
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
    
    var body: some View {
        ZStack {
            ZStack {
                //bottone
                ZStack {
                    if !isActivated{
                        CustomColor.background
                    }
                    if isActivated{
                        withAnimation {
                            Color(.red)
                        }
                    }
                    
                    ZStack {
                        
                        if isPressed {
                            RingView(percentage: 1, backgroundColor: Color.background.opacity(0), startColor: .white, endColor: .white, thickness: 37)
                                .scaleEffect(0.671)
                        }
                        
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 170, height: 170)
                            .shadow(radius: 7)
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 75, height: 70)
                            .foregroundColor(Color("Triangle"))
                            .opacity(showMark ? 1 : 0)
                    }//fine zstack
                    .onTapGesture {
                        sendMessage()
                        if isActivated{
                            withAnimation{
                                showCircle = false
                                showMark = true
                                isActivated.toggle()
                            }
                            restart()
                        }
                    }
                    .onLongPressGesture(minimumDuration: 0.5){
                        if isActivated{
                            print("yuri")
                        }
                        else{
                            withAnimation {
                                isPressed = true
                                showCircle = true
                                showMark = false
                                timerStart()
                                isActivated.toggle()
                            }
                        }
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
                        .opacity(withAnimation{
                            start ? 1 : 0
                        })
            }//fine zstack
            .ignoresSafeArea()
        }//fine zstack
        .bottomSheet(presentationDetents: [.medium, .large, .height(70)], isPresented: .constant(true), sheetCornerRadius: 20) {
            ScrollView(.vertical, showsIndicators: false) {
                ModalView(showAlert: $showAlert, start: $start, count: $count, to: $to)
            }
        } onDismiss: {}
            .onAppear(perform: {
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
                        self.showAlert = true
                        self.Notify()
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
