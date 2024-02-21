//
//  ModalView.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import SwiftUI
import MapKit

struct ModalView: View {
    @StateObject private var viewModel = MapViewModel()
    @Binding var showAlert: Bool
    @Binding var start: Bool
    @Binding var count: Int
    @Binding var to: CGFloat
    @State private var dismissTimer: Timer?
    
    let Yuri = CLLocationCoordinate2D(latitude: 40.826823770004644, longitude: 14.196899024494087)
//    @State var camera: MapCameraPosition = .region(self.viewModel.region)
    
    func timerRestart(){
        if self.count == 0 {
            self.count = 10 // Riporta il timer a 5 minuti
            withAnimation(.default){
                self.to = 0
            }
        }
        self.start.toggle()
        print("start")
    }
    
    var body: some View {
         //NavigationView{
            VStack{
                HStack(alignment: .center, spacing: 200.0){
                    Text("Safe Places")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    NavigationLink(destination: UserProfileView()){
                        ZStack{
                            Circle()
                                .frame(width:40)
                                .foregroundColor(.gray)
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.vertical, 20)
                
                MapView()
                    .onAppear{viewModel.checkIfLocationEnabled()}
                    .frame(width: 363, height: 510)
                    .cornerRadius(5)
                
                
                VStack(alignment: .leading){
                    Text("Services")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    ZStack{
                        Rectangle()
                            .frame(width:363, height:100)
                            .cornerRadius(10)
                            .foregroundStyle(.gray)
                            .opacity(0.4)
                        
                        HStack(spacing: 20.0){
                            ButtonHomeView(iconName: "phone.fill.arrow.down.left", nameFeature:"Fake Calls")
                            ButtonHomeView(iconName: "paperplane.fill", nameFeature:"Safe Routes")
                            ButtonHomeView(iconName: "exclamationmark.bubble.fill", nameFeature:"Reports")
                            ButtonHomeView(iconName: "waveform.and.mic", nameFeature:"Walkie-Talkie")
                        }
                    }
                }
                .padding(.top, 10.0)
               
                
            }
            .alert(isPresented: $showAlert) {
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
        //}
    }
}

//#Preview {
//    ModalView()
//}
