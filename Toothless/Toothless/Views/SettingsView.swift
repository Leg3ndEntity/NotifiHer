//
//  SettingsView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 29/02/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Query var userData: [User]
    
    @State private var randomColor: Color
    
    func shareLink() {
        let url = URL(string: "https://testflight.apple.com/join/UjB0xSRP")!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    init(userData: [User]) {
        if let savedColorData = UserDefaults.standard.data(forKey: "userProfileColor"),
           let savedColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
            self._randomColor = State(initialValue: Color(savedColor))
        } else {
            let hue = Double.random(in: 0...1)
            let saturation = Double.random(in: 0.5...1)
            let brightness = Double.random(in: 0.5...1)
            self._randomColor = State(initialValue: Color(hue: hue, saturation: saturation, brightness: brightness))
            
            if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(self.randomColor), requiringSecureCoding: false) {
                UserDefaults.standard.set(colorData, forKey: "userProfileColor")
            }
        }
    }
    
    @State var url = URL(string: "https://www.iubenda.com/privacy-policy/49969320")
    var body: some View {
        let initials = String(userData[0].name.prefix(1) + userData[0].surname.prefix(1))
        
        NavigationStack{
            VStack{
                List{
                    Section{
                        HStack(spacing: 25.0) {
                            ZStack {
                                Circle()
                                    .fill(randomColor)
                                    .frame(width: 35, height: 35)
                                //Text("SS")
                                Text(initials)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            VStack(alignment: .leading, spacing: -2.0){
                                Text("\(userData[0].name) \(userData[0].surname)")
                                //Text("Simone Sarnataro")
                                    .fontWeight(.medium)
                                Text("\(userData[0].phoneNumber)")
                                //Text("+39 3716703252")
                                    .font(.subheadline)
                            }
                        }.accessibilityElement(children: .combine)
                    }
                    Section(header: Text("System")){
                        NavigationLink {
                            //UserProfileView(userData: [])
                            GoalView()
                        } label: {
                            Text("Change time")
                        }
                        
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            HStack {
                                Text("Notification")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(CustomColor.customred)
                            }
                        }
                        
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            HStack {
                                Text("Change Language")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.forward")
                                    .foregroundStyle(CustomColor.customred)
                            }
                        }
                    }
                    Section(header: Text("About")){
                        
                        HStack {
                            Text("Share NotifiHer")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.primary)
                        }.onTapGesture {
                            shareLink()
                        }
                        
                    }
                    Section(header: Text("Privacy")){
                        HStack {
                            Link("Privacy Policy", destination: url!)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .foregroundStyle(CustomColor.customred)
                        }.onTapGesture {
                            if let url = URL(string: "https://www.iubenda.com/privacy-policy/49969320") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    //                    Section(header: Text("More features")) {
                    //                        Text("Widgets")
                    //                        Text("")
                    //                    }.listRowBackground(Color.clear)
                }
                .navigationTitle("Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem{
                        Button{
                            dismiss()
                        }label:{
                            Text("Done")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                        }
                    }
                })
                
                
            }
        }
    }
}

#Preview {
    SettingsView(userData: [])
}
