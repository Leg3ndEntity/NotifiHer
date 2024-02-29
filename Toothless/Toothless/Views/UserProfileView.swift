import SwiftUI

struct UserProfileView: View {
    var email: String
    var firstName: String
    var lastName: String
    var userID: String
    
    var body: some View {
        VStack {
            Text("Welcome, \(firstName) \(lastName)!")
                .font(.largeTitle)
                .padding()
            
            Text("Your email is: \(email)")
                .font(.title)
                .padding()
            
            Text("Your user ID is: \(userID)")
                .font(.title)
                .padding()
        }
    }
}

#Preview {
    UserProfileView(email: "", firstName: "", lastName: "", userID: "")
}
