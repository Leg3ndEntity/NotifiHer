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
    @ObservedObject var viewModel: MapViewModel = MapViewModel()
    
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
                }.accessibilityElement(children: .combine).accessibility(label: Text("Profile"))
                .onTapGesture {
                    modal5.toggle()
                    feedbackGenerator.impactOccurred()
                }
            }
            .padding(.vertical, 20)
            VStack(alignment: .leading){
                HStack(spacing: 28){
                    ButtonHomeView(iconName: "map.fill", nameFeature: NSLocalizedString("Map", comment: ""), showModal: $modal1)
                        .accessibilityElement(children: .combine)
                        .accessibility(label: Text("Map"))
                    ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature: NSLocalizedString("Fake Calls", comment: ""), showModal: $modal2)
                        .accessibilityElement(children: .combine)
                        .accessibility(label: Text("Fake Calls"))
                    ButtonHomeView(iconName: "person.fill", nameFeature: NSLocalizedString("Contacts", comment: ""), showModal: $modal3)
                        .accessibilityElement(children: .combine)
                        .accessibility(label: Text("Contacts"))
                    ButtonHomeView(iconName: "waveform.and.mic", nameFeature: NSLocalizedString("WT", comment: ""), showModal: $modal4)
                        .accessibilityElement(children: .combine)
                        .accessibility(label: Text("Walkie-Talkie"))
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
                UserProfileView(userData: [])
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
