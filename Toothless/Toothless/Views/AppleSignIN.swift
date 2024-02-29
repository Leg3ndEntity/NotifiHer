//
//  AppleSignIN.swift
//  Toothless
//
//  Created by Andrea Romano on 29/02/24.
//

import SwiftUI
import AuthenticationServices

struct AppleSignIN: View {
    @Binding var isUserSignedIn: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userID") var userID: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if userID.isEmpty {
                    SignInWithAppleButton(.continue) { request in
                        
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        
                        switch result {
                        case .success(let auth):
                            self.isUserSignedIn = true
                            
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                
                                let userID = credential.user
                                
                                let email = credential.email
                                let firstName = credential.fullName?.givenName
                                let lastName = credential.fullName?.familyName
                                
                                self.email = email ?? ""
                                self.userID = userID
                                self.firstName = firstName ?? ""
                                self.lastName = lastName ?? ""
                                
                            default:
                                break
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .frame(height: 50)
                    .padding()
                    .cornerRadius(8)
                    
                }
                else {
                    Text("Welcome!")
                        .onAppear {
                            // Set isUserSignedIn to true when "Welcome!" appears
                            self.isUserSignedIn = true
                        }
                }
            }
        }
    }
}

