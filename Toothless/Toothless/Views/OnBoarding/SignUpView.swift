//
//  SignUpView.swift
//  Toothless
//
//  Created by Andrea Romano on 01/03/24.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var generatedCode: String = ""
    let customDocumentID = "customDocumentID123"
    
    @EnvironmentObject var database: Database
    @Environment(\.modelContext) var modelContext
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isShowingMain: Bool = false
    @State var showLogin: Bool = false
    @State private var isUserSignedIn: Bool = false
    
    var fcmToken: String? {
        UserDefaults.standard.string(forKey: "fcmToken")
    }
    
    private func generateUniqueCode() -> String {
        var code = ""
        repeat {
            let randomNumber = String(format: "%06d", Int.random(in: 0...999999))
            code = randomNumber
            database.searchUserByPhoneNumber(phoneNumber: code) { result in
                if result != nil {
                    code = generateUniqueCode()
                }
            }
        } while false
        return code
    }
    
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("uid") var userID: String = ""
    //@Binding var currentShowingView: String
    @Environment(\.colorScheme) var colorScheme
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.[a-z])(?=.[$@$#!%?&])(?=.[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .white)
            
            VStack {
                HStack {
                    Text("Create an Account!")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                HStack {
                    TextField("Name", text: $name)
                        .accessibilityRemoveTraits(.isStaticText)
                }.foregroundStyle(colorScheme == .dark ? .white : .black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    )
                    .padding()
                HStack {
                    TextField("Surname", text: $surname)
                        .accessibilityRemoveTraits(.isStaticText)
                }.foregroundStyle(colorScheme == .dark ? .white : .black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        
                    )
                    .padding()
                HStack {
                    Image(systemName: "mail").foregroundStyle(colorScheme == .dark ? .white : .black)
                    TextField("Email", text: $email).foregroundStyle(colorScheme == .dark ? .white : .black)
                    if(email.count != 0) {
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                )
                .padding()
                VStack(alignment: .leading, spacing: -8.0) {
                    Text("You must use a capital letter and a special character")
                        .font(.caption2)
                        .padding(.leading, 30)
                        .foregroundStyle(colorScheme == .dark ? .gray : .gray)
                    HStack {
                        Image(systemName: "lock").foregroundStyle(colorScheme == .dark ? .white : .black)
                        SecureField("Password", text: $password).foregroundStyle(colorScheme == .dark ? .white : .black)
                        if(password.count != 0) {
                            Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                                .fontWeight(.bold)
                                .foregroundColor(isValidPassword(password) ? .green : .red)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        
                    )
                    .padding()
                }
                
                
                Button(action: {
                    withAnimation {
                        //self.currentShowingView = "login"
                        showLogin.toggle()
                    }
                }) {
                    Text("Already have an account?")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                
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
                    let user = User(name: name, surname: surname, phoneNumber: generatedCode, fcmToken: fcmToken ?? "")
                    database.addUser(user: user, phoneNumber: user.phoneNumber)
                    isWelcomeScreenOver = true
                    isShowingMain.toggle()
                    modelContext.insert(user)
                    print("ciao")
                } label: {
                    Text("Create New Account")
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
                }.padding(.top, 30)
                
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || surname.trimmingCharacters(in: .whitespaces).isEmpty||email.trimmingCharacters(in: .whitespaces).isEmpty||password.trimmingCharacters(in: .whitespaces).isEmpty||isValidPassword(password))
                Spacer()
            }
            
        }
        .onAppear {
            generatedCode = generateUniqueCode()
        }
        .fullScreenCover(isPresented: $isShowingMain, content: {
            CompleteTimer()
        })
        .fullScreenCover(isPresented: $showLogin, content: {
            LoginView()
        })
    }
}

//struct SignupView_Previews: PreviewProvider {
//    @State static var currentShowingView: String = "signup"
//
//    static var previews: some View {
//        SignupView(currentShowingView: $currentShowingView)
//            .preferredColorScheme(.none) // Optionally, set the color scheme for preview
//    }
//}
