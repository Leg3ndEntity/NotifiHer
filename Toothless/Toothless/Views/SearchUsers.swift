//import SwiftUI
//import SwiftData
//import Firebase
//import FirebaseFirestore
//
//
//class TokenManager: ObservableObject {
//    @Published var savedToken: String?
//    
//    func saveToken(_ token: String) {
//        print("Attempting to save token: \(token)")
//        savedToken = token
//        print("Token saved: \(savedToken ?? "nil")")
//    }
//}
//
//
//struct SearchUsers: View {
//    @State private var searchText: String = ""
//    @ObservedObject var database: Database = Database()
//    @State private var foundToken: String? = nil
//    @Environment(\.colorScheme) var colorScheme
//    @StateObject private var tokenManager = TokenManager()
//    
//    @State private var isTokenSaved: Bool = false
//    
//    @Environment(\.modelContext) var modelContext
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Image(systemName: "phone").foregroundStyle(colorScheme == .dark ? .white : .black)
//                TextField("Password", text: $searchText)
//                
//                Spacer()
//                
//            }
//            .padding()
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(lineWidth: 2)
//                    .foregroundStyle(colorScheme == .dark ? .white : .black)
//                
//            )
//            .padding()
//            .onChange(of: searchText) { newSearchText in
//                // Perform search when the search text changes
//                database.searchUserByPhoneNumber(phoneNumber: newSearchText) { fcmToken in
//                    if let fcmToken = fcmToken {
//                        // Handle the found fcmToken
//                        foundToken = fcmToken
//                    } else {
//                        // Handle case when the phone number is not found
//                        foundToken = nil
//                    }
//                    // Reset the token saved flag when the search text changes
//                    isTokenSaved = false
//                }
//            }
//            
//            
//            
//            if let token = foundToken {
//                if let savedToken = tokenManager.savedToken {
//                    Text("Token is saved: \(savedToken)")
//                        .padding()
//                } else {
//                    Button(action: {
//                        tokenManager.saveToken(token)
//                        modelContext.insert(UserToken(fcmToken: token))
//                    }) {
//                        Text("Save Token")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//            } else {
//                Text("Phone number not found")
//                    .padding()
//            }
//        }
//        .environmentObject(tokenManager) // Inject the TokenManager into the environment
//    }
//}
//
////#if DEBUG
////struct SearchUsers_Previews: PreviewProvider {
////    static var previews: some View {
////        SearchUsers(searchText: "123456789", database: Database(), foundToken: "abc123")
////    }
////}
////#endif
//
