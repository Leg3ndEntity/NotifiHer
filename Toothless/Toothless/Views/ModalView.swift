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
    @State private var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    
    @Binding var isActivated: Bool
    @Binding var showMark: Bool
    
    @Binding var showAlert: Bool
    @Binding var showAlert2: Bool
    
    @Binding var start: Bool
    @Binding var count: Int
    @Binding var to: CGFloat
    @State private var dismissTimer: Timer?
    
    func restart(){
        start = false
        self.count = 300
        self.to = 0
        print("restart")
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
        VStack{
            HStack(alignment: .center, spacing: 200.0){
                Text("Safe Places")
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
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
                }
            }
            .padding(.vertical, 20)
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    ButtonHomeView(iconName: "map.fill", nameFeature:"Map", showModal: $modal1)
                    ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature:"Fake Calls", showModal: $modal2)
                    ButtonHomeView(iconName: "exclamationmark.bubble.fill", nameFeature:"Reports", showModal: $modal3)
                    ButtonHomeView(iconName: "waveform.and.mic", nameFeature:"Walkie-Talkie", showModal: $modal4)
                }
            }
            .padding(.top, 10.0)
            
            
        }
        .bottomSheet2(presentationDetents: [.large], isPresented: $modal1, sheetCornerRadius: 20) {
            MapView()
        } onDismiss: {}
//            .sheet(isPresented: $modal2, content: {
//                UserProfileView()
//            })
//            .sheet(isPresented: $modal3, content: {
//                UserProfileView()
//            })
//            .sheet(isPresented: $modal4, content: {
//                UserProfileView()
//            })
            .sheet(isPresented: $modal5, content: {
                UserProfileView()
            })
            .onAppear {
                feedbackGenerator.prepare()
            }
            .onDisappear {
                feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you ok?"),
                    message: Text("If you don’t dismiss this notification, a default message will be sent to your emergency contact"),
                    dismissButton: .default(
                        Text("Dismiss"),
                        action: {
                            timerRestart()
                            self.dismissTimer?.invalidate()
                            showAlert = false
                            feedbackGenerator.impactOccurred()
                            
                        }
                    )
                )
            }
            .alert(isPresented: $showAlert2) {
                Alert(
                    title: Text("Are you sure?"),
                    primaryButton: .default(
                        Text("Dismiss"),
                        action: {
                            withAnimation{
                                restart()
                                self.dismissTimer?.invalidate()
                                showAlert = false
                                isActivated = false
                                showMark = true
                                feedbackGenerator.impactOccurred()
                            }
                        }
                    ),
                    secondaryButton: .default(
                        Text("Never mind"),
                        action: {
                            showAlert = false
                            feedbackGenerator.impactOccurred()
                        }
                    )
                )
            }
    }
}

//#Preview {
//    ModalView()
//}
