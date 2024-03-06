//
//  CompleteTimer.swift
//  Toothless_prova
//
//  Created by Simone Sarnataro on 17/02/24.
//

import SwiftUI
import UIKit
import SwiftData
import CoreLocation

struct CompleteTimer: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tokenManager: TokenManager
    @Query var userData: [UserToken]
    @Query var user: [User]
    @Query var contactsData: [Contacts] = []
    @Query var counter: [Counter]
    
    @State var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    @State var selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    @StateObject private var viewModel = MapViewModel()
    
    @State var canCancel: Bool = false
    @State var buttonTapped: Bool = false
    @State var isActivated: Bool = false
    @State var isPressed: Bool = false
    
    @State var buttonLocked = false
    @State var showAlert: Bool = false
    @State var showCancel: Bool = false
    @State var showCircle: Bool = false
    @State var circleOpacity = false
    @State var showMark: Bool = true
    @State var textSwap = true
    
    @State var start = false
    @State var to : CGFloat = 0
    @State var count = 300
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var dismissTimer: Timer?
    
    var changeFunction: (() -> Void)?
    //    var formattedTime: String {
    //        let minutes = count / 60
    //        let seconds = count % 60
    //        return String(format: "%d:%02d", minutes, seconds)
    //    }
    var formattedTime: String {
        if let lastCounter = counter.last {
            count = lastCounter.counter
            let minutes = count / 60
            let seconds = count % 60
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            let minutes = count / 60
            let seconds = count % 60
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    var rotationAngle: Angle {
        let progress = 1 - to
        return .degrees(Double(progress) * 360 - 90)
    }
    func getBatteryLevel() -> Int {
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryPercentage = Int(batteryLevel * 100)
        return batteryPercentage
    }
    
    func scheduleNotificationsAtIntervals() {
        let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            scheduleNotification()
        }
        timer.fire()
    }
    func scheduleNotification() {
        for contact in contactsData{
            guard let savedToken = contact.token else {
                print(contact.token ?? "banana")
                print("Token not found")
                return
            }
            
            viewModel.checkIfLocationEnabled()
            guard let currentLocation = viewModel.locationManager?.location?.coordinate else {
                print("Impossibile ottenere la posizione dell'utente")
                return
            }
            let userLocationURL = "https://maps.apple.com/?ll=\(currentLocation.latitude),\(currentLocation.longitude)"
            // Construct the notification content
            let content = UNMutableNotificationContent()
            content.title = "\(user[0].name) \(user[0].surname) is in danger"
            content.body = "Open the app to check on them \nPosizione: \(userLocationURL)"
            content.sound = UNNotificationSound.default
            content.userInfo = ["token": savedToken]
            
            
            // Construct the JSON payload for the FCM request
            let fcmPayload: [String: Any] = [
                "to": savedToken,
                "notification": [
                    "title": "\(user[0].name) \(user[0].surname) is in danger",
                    "body": "Open the app to check on them \nPosizione: \(userLocationURL)",
                    "sound": "default"
                ]
            ]
            
            // Convert the payload to Data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: fcmPayload) else {
                print("Error converting payload to Data")
                return
            }
            
            // Define the FCM endpoint URL
            guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {
                print("Invalid FCM URL")
                return
            }
            let serverKey = "AAAARm8nQLE:APA91bE1wWWiZxn_hTw8UexqrQJPUEYhx8eQBzqaZlco0M8d1-yviBlHS8EAPV4XQNPXuZtDbKsg5mvp0k-1nDuIm-Blnd_XRAB-Xo3CabxdeIP_4F2h-SQihJr5e_Q5kR8LoAtianGr"
            // Create the URLRequest
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            // Perform the HTTP request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending FCM request:", error)
                } else if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("FCM request sent successfully:", responseString ?? "")
                }
                // Check for specific error
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 400,
                   let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let error = results.first?["error"] as? String,
                   error == "InvalidApnsCredential" {
                    print("Invalid APNs credential. Please check your APNs configuration.")
                    // Handle the error accordingly
                }
            }.resume()
            
        }
    }
    
    //    func timerStart() {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
    //            isPressed = false
    //            if isActivated {
    //                self.count = 300
    //                self.start.toggle()
    //                print("start")
    //                canCancel = true // Set the flag to allow cancellation
    //            }
    //        }
    //    }
    func timerStart() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            isPressed = false
            if isActivated {
                // Imposta il valore di self.count utilizzando l'ultimo counter salvato
                if let lastCounter = counter.last {
                    count = lastCounter.counter
                    self.start.toggle()
                    canCancel = true
                    print("start")
                } else {
                    self.count = 300
                    self.start.toggle()
                    canCancel = true
                    print("start")
                }
            }
        }
    }
    
    func TapAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                self.buttonTapped = false
            }
        }
    }
    
    func SwapText(){
        if textSwap{
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.smooth(duration: 1)) {
                    textSwap.toggle()
                    SwapText()
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1)) {
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
                    if isActivated{
                        showCircle.toggle()
                        CircleAnimation()
                    }else{
                        print("stop animazione cerchi")
                        showCircle = false
                    }
                } else {
                    print("stop animazione cerchi")
                    showCircle = false
                }
            }
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
                            HStack {
                                Text("TAP")
                                    .foregroundStyle(.red)
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .offset(x: 0, y: -150)
                                Text("to send an alert")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .offset(x: 0, y: -150)
                            }
                        }else{
                            HStack {
                                Text("HOLD")
                                    .foregroundStyle(.red)
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .offset(x: 0, y: -150)
                                Text("to start the timer")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .offset(x: 0, y: -150)
                            }
                        }
                    }
                    
                    if isPressed {
                        RingView(percentage: 1, backgroundColor: Color.white.opacity(0), startColor: .white, endColor: .white, thickness: 37)
                            .scaleEffect(0.671)
                    }
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .opacity(circleOpacity ? 0.3 : 0)
                            .frame(width: showCircle ? 270 : 170)
                        Circle()
                            .foregroundColor(.white)
                            .opacity(circleOpacity ? 0.3 : 0)
                            .frame(width: showCircle ? 220: 170)
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
                        DispatchQueue.main.async {
                            if !buttonLocked && !isActivated{
                                buttonTapped = true
                                TapAnimation()
                                withAnimation{
                                    isActivated = true
                                    CircleAnimation()
                                    circleOpacity = true
                                    showCancel = true
                                    canCancel = true
                                }
                                feedbackGenerator.impactOccurred()
                                scheduleNotification()
                            }
                        }
                    }//fine onTapGesture
                    .onLongPressGesture {
                        DispatchQueue.main.async {
                            if !isActivated && !start {
                                withAnimation {
                                    timerStart()
                                    isActivated = true
                                    isPressed = true
                                    showMark = false
                                    showCancel = true
                                }
                                selectionFeedbackGenerator.selectionChanged()
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
                    if isActivated && canCancel{
                        feedbackGenerator.impactOccurred()
                        circleOpacity = false
                        isActivated = false
                        showCancel = false
                        start = false
                        showMark = true
                        canCancel = false
                        
                        buttonLocked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            buttonLocked = false
                        }
                        
                    }
                }
                //                Circle()
                //                    .trim(from: 0, to: self.to)
                //                    .stroke(Color.white.opacity(start ? 1 : 0), style: StrokeStyle(lineWidth: 25, lineCap: .round))
                //                    .frame(width: 214.5, height: 214.5)
                //                    .rotationEffect(rotationAngle)
                //                    .onReceive(self.time) { _ in
                //                        self.to = CGFloat(self.count) / 300
                //                    }
                Circle()
                    .trim(from: 0, to: self.to)
                    .stroke(Color.white.opacity(start ? 1 : 0), style: StrokeStyle(lineWidth: 25, lineCap: .round))
                    .frame(width: 214.5, height: 214.5)
                    .rotationEffect(rotationAngle)
                    .onReceive(self.time) { _ in
                        if let lastCounter = counter.last {
                            self.to = CGFloat(self.count) / CGFloat(lastCounter.counter)
                        } else {
                            self.to = CGFloat(self.count) / 300
                        }
                    }
                
                Text("\(formattedTime)")
                    .foregroundStyle(Color("Timer"))
                    .font(.system(size: 65))
                    .fontWeight(.bold)
                    .opacity(withAnimation{
                        start ? 1 : 0
                    })
            }//fine 2° Zstack
            .ignoresSafeArea()
        }//fine 3° Zstack
        .bottomSheet(presentationDetents: [.height(190), .height(80)], isPresented: .constant(true), sheetCornerRadius: 20) {
            ScrollView(.vertical, showsIndicators: false) {
                ModalView(showMark: $showMark, showCircle: $showCircle, showAlert: $showAlert, circleOpacity: $circleOpacity, start: $start, count: $count, to: $to, dismissTimer: $dismissTimer)
            }
        } onDismiss: {}
            .onAppear(perform: {
                selectionFeedbackGenerator.prepare()
                feedbackGenerator.prepare()
                SwapText()
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
                }
            })
            .onDisappear {
                feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            }
            .onReceive(self.time) { _ in
                DispatchQueue.main.async {
                    if self.start {
                        if self.count > 0 {
                            self.count -= 1
                            print("\(self.count)")
                        } else {
                            print("ciao")
                            start.toggle()
                            showAlert = true
                            dismissTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                                print("Popup alert ignored for 10 seconds")
                                showAlert = false
                                showMark = true
                                CircleAnimation()
                                circleOpacity = true
                            }
                            
                        }
                    }
                }
            }
    }
}
//
//#Preview {
//    CompleteTimer()
//}
