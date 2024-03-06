//
//  ModalView.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import SwiftUI
import MapKit
import UIKit
import SwiftData

struct ModalView: View {
    @State var modal1: Bool = false
    @State var modal2: Bool = false
    @State var modal3: Bool = false
    @State var modal4: Bool = false
    @State var modal5: Bool = false
    @State var feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    @Binding var showMark: Bool
    @Binding var showCircle: Bool
    @Binding var showAlert: Bool
    @Binding var circleOpacity: Bool
    
    @Binding var start: Bool
    @Binding var count: Int
    @Binding var to: CGFloat
    @Binding var dismissTimer: Timer?
    
    @Query var user: [User]
    @Query var counter: [Counter]
    @Query var contactsData: [Contacts] = []
    @StateObject private var viewModel = MapViewModel()
    
//    func timerRestart(){
//        if self.count == 0 {
//            self.count = 300
//            withAnimation(.default){
//                self.to = 0
//            }
//        }
//        self.start.toggle()
//        print("start")
//    }
    func timerRestart() {
        if let lastCounter = counter.last {
            if self.count == 0 {
                self.count = lastCounter.counter
                withAnimation(.default){
                    self.to = 0
                }
            }
            self.start.toggle()
            print("start")
        } else {
            if self.count == 0 {
                self.count = 300
                withAnimation(.default) {
                    self.to = 0
                }
            }
            self.start.toggle()
            print("start")
        }
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
    
    var body: some View {
        VStack{
            HStack(){
                Text("Services")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
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
            }.frame(width: 350)
            .padding(.vertical, 20)
            VStack(alignment: .leading){
                HStack(spacing: 28){
                    ButtonHomeView(iconName: "map.fill", nameFeature:NSLocalizedString("Map", comment: ""), showModal: $modal1)
                    ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature:NSLocalizedString("Fake Calls", comment: ""), showModal: $modal2)
                    ButtonHomeView(iconName: "person.fill", nameFeature:NSLocalizedString("Contacts", comment: ""), showModal: $modal3)
                    ButtonHomeView(iconName: "waveform.and.mic", nameFeature:NSLocalizedString("WT", comment: ""), showModal: $modal4)
                }
            }.padding(.top, 10.0)
            
            
        }
        .bottomSheet2(presentationDetents: [.large], isPresented: $modal1, sheetCornerRadius: 20) {
            MapView()
        } onDismiss: {}
                    .sheet(isPresented: $modal2, content: {
                        FakeCallView()
                    })
                    .sheet(isPresented: $modal3, content: {
                        ContactsView()
                    })
//                    .sheet(isPresented: $modal4, content: {
//                        ContactsView()
//                    })
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
