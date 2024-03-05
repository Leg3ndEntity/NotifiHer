import SwiftUI
import SwiftData

struct UserProfileView: View {
    @Query var userData: [User]
    @Environment(\.dismiss) var dismiss
    @State private var randomColor: Color
    
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
    
    var body: some View {
        let initials = String(userData[0].name.prefix(1) + userData[0].surname.prefix(1))
        
        VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding(.trailing, 25)
                    }
                    .padding(.top, -150)
                    
                    VStack {
                        ZStack {
                            Circle()
                                .fill(randomColor)
                                .frame(width: 120, height: 120)
                            Text(initials)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }.accessibilityHidden(true)
                        .padding()
                        .padding(.bottom, 30)
                        
                        VStack(alignment: .center) {
                            Text("Welcome,")
                                .font(.largeTitle)
                            Text("\(userData[0].name) \(userData[0].surname)!")
                                .font(.largeTitle)
                        }
                        .padding()
                        
                        VStack(alignment: .center) {
                            Text("Your phone number is:")
                                .font(.title)
                            Text("\(userData[0].phoneNumber)")
                                .font(.title)
                        }
                    }
                    .navigationBarTitle("Account")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }

#Preview {
    UserProfileView(userData: [])
}
