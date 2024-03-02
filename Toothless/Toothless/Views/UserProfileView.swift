import SwiftUI
import SwiftData

struct UserProfileView: View {
    @Query var userData: [User]
    @State private var randomColor: Color
    //@EnvironmentObject var tokenManager: TokenManager
    @StateObject private var tokenManager = TokenManager()
    
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
            
            ZStack {
                Circle()
                    .fill(randomColor)
                    .frame(width: 100, height: 100)
                //Text("SS")
                Text(initials)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            //Text("Welcome!")
            Text("Welcome, \(userData[0].name) \(userData[0].surname)!")
                .font(.largeTitle)
                .padding()
            //Text("Your phone number is")
            Text("Your phone number is: \(userData[0].phoneNumber)")
                .font(.title)
                .padding()
            Text("Your token is: \(userData[0].fcmToken)")
                .font(.title)
                .padding()
            if let savedToken = tokenManager.savedToken {
                Text("Token is saved: \(savedToken)")
                    .padding()
            } else {
                Text("Token not found")
                    .padding()
            }
            if let savedToken = UserDefaults.standard.string(forKey: "savedToken") {
                Text("Token is saved: \(savedToken)")
                    .padding()
            } else {
                Text("Token not found")
                    .padding()
            }
        }.environmentObject(tokenManager)
    }
}

#Preview {
    UserProfileView(userData: [])
}
