//
//  SignUpView.swift
//  Toothless
//
//  Created by Andrea Romano on 01/03/24.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("uid") var userID: String = ""
    @Binding var currentShowingView: String
    @Environment(\.colorScheme) var colorScheme
    
    private func isValidPassword(_ password: String) -> Bool {
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special char
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .white)
            
            VStack {
                HStack {
                    Text("Create an Account!").accessibilityLabel("Create an Account!")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Image(systemName: "mail").accessibilityHidden(true)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    TextField("Email", text: $email).accessibilityHidden(true)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    
                    if(email.count != 0) {
                        
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }.accessibility(label: Text("Email")).accessibilityHint("Insert your email")
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                )
                
                .padding()
                
                
                HStack {
                    Image(systemName: "lock").accessibilityHidden(true)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    SecureField("Password", text: $password).accessibilityHidden(true)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Spacer()
                    
                    if(password.count != 0) {
                        
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }.accessibility(label: Text("Password")).accessibilityHint("Insert your password")
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                )
                .padding()
                
                
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "login"
                    }
                }) {
                    Text("Already have an account?").accessibilityLabel("Already have an account?").accessibilityHint("Click to sign up")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                
                Spacer()
                Spacer()
                
                
                Button {
                    
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            userID = authResult.user.uid
                            
                        }
                    }
                    
                } label: {
                    Text("Create New Account").accessibilityLabel("Sign Up").accessibilityHint("Click to sign up")
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(colorScheme == .dark ? .white : .black))
                        )
                        .padding(.horizontal)
                }
            }
            
        }
    }
}


