//
//  ModalView.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import SwiftUI
import MapKit
import UIKit

struct ModalView: View {
    @State var modal1: Bool = false
    @State var modal2: Bool = false
    @State var modal3: Bool = false
    @State var modal4: Bool = false
    @State var modal5: Bool = false
    @State var feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    @EnvironmentObject var tokenManager: TokenManager
    
    @Binding var showMark: Bool
    @Binding var showCircle: Bool
    @Binding var showAlert: Bool
    @Binding var circleOpacity: Bool
    
    @Binding var start: Bool
    @Binding var count: Int
    @Binding var to: CGFloat
    @Binding var dismissTimer: Timer?
    
    func timerRestart(){
        if self.count == 0 {
            self.count = 300
            withAnimation(.default){
                self.to = 0
            }
        }
        self.start.toggle()
        print("start")
    }
    func CircleAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showCircle.toggle()
                CircleAnimation()
                circleOpacity = true
            }
        }
    }
    func scheduleNotification() {
            guard let savedToken = userData[0].fcmToken else {
                print("Token not found")
                return
            }

            // Create a notification content
            let content = UNMutableNotificationContent()
            content.title = "Timer Alert"
            content.body = "Your timer has finished!"
            content.sound = UNNotificationSound.default
            content.userInfo = ["token": savedToken]

            // Create a trigger for the notification (you can customize this based on your needs)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

            // Create a request with a unique identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // Schedule the notification
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        }

    
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 215){
                Text("Services")
                    .font(.title3)
                    .fontWeight(.bold)
                ZStack{
                    Circle()
                        .frame(width:40)
                        .foregroundColor(.gray)
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }.onTapGesture {
                    modal5.toggle()
                    feedbackGenerator.impactOccurred()
                }
            }
            .padding(.vertical, 20)
            VStack(alignment: .leading){
                HStack(spacing: 28){
                    ButtonHomeView(iconName: "map.fill", nameFeature:"Map", showModal: $modal1)
                    ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature:"Fake Calls", showModal: $modal2)
                    ButtonHomeView(iconName: "exclamationmark.bubble.fill", nameFeature:"Reports", showModal: $modal3)
                    ButtonHomeView(iconName: "waveform.and.mic", nameFeature:"WT", showModal: $modal4)
                }
            }.padding(.top, 10.0)
            
            
        }
        .bottomSheet2(presentationDetents: [.large], isPresented: $modal1, sheetCornerRadius: 20) {
            MapView()
        } onDismiss: {}
//                    .sheet(isPresented: $modal2, content: {
//                        SearchUsers()
//                    })
                    .sheet(isPresented: $modal3, content: {
                        SearchUsers()
                    })
        //            .sheet(isPresented: $modal4, content: {
        //                UserProfileView()
        //            })
            .sheet(isPresented: $modal5, content: {
                SettingsView(userData: [])
            })
            .onAppear {
                feedbackGenerator.prepare()
            }
            .onDisappear {
                feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you safe?"),
                    
                    primaryButton: .default(
                        Text("Yes"),
                        action: {
                            withAnimation{
                                dismissTimer?.invalidate()
                                timerRestart()
                                feedbackGenerator.impactOccurred()
                            }
                        }
                    ),
                    secondaryButton: .default(
                        Text("No, help me"),
                        action: {
                            scheduleNotification()
                            CircleAnimation()
                            circleOpacity = true
                            dismissTimer?.invalidate()
                            feedbackGenerator.impactOccurred()
                            showMark = true
                        }
                    )
                )
            }
    }
}

//#Preview {
//    ModalView()
//}
