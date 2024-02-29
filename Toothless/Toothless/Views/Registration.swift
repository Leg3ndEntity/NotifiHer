
import SwiftUI

struct Registration: View {
    
    @State var name: String
    @State var surname: String
    @State var phoneNumber: String
    
    var fcmToken: String? {
        UserDefaults.standard.string(forKey: "fcmToken")
    }
    
    var body: some View {
        VStack {
            Text("Set up personal details")
                .font(.title)
                .bold()
            
            Text("Your personal details are the basic information the app needs to help you in case of danger.")
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .frame(width: 350)
                .padding(.top, 1)
                .padding(.bottom, 50)
            
            Divider()
            
            HStack {
                Text("First Name").bold()
                TextField("Required", text: $name)
                    .accessibilityRemoveTraits(.isStaticText)
                    .padding(.leading, 20)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            
            Divider()
            
            HStack {
                Text("Last Name").bold()
                TextField("Required", text: $surname)
                    .accessibilityRemoveTraits(.isStaticText)
                    .padding(.leading, 20)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            
            Divider()
            
            HStack {
                Text("Phone Number").bold()
                TextField("Required", text: $phoneNumber)
                    .accessibilityRemoveTraits(.isStaticText)
                    .padding(.leading, 20)
                    .keyboardType(.numberPad)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            
            Divider().padding(.bottom, 50)
            
            if let fcmToken = fcmToken {
                Text("FCM Token: \(fcmToken)")
                    .padding()
            }
        }
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration(name: "", surname: "", phoneNumber: "")
    }
}
