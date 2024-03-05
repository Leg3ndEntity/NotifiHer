//
//  AddContact.swift
//  Toothless
//
//  Created by Simone Sarnataro on 02/03/24.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseFirestore

class TokenManager: ObservableObject {
    @Published var savedToken: String?
    
    func saveToken(_ token: String) {
        print("Attempting to save token: \(token)")
        savedToken = token
        print("Token saved: \(savedToken ?? "nil")")
    }
}

struct AddContact: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @ObservedObject var database: Database = Database()
    @StateObject var tokenManager = TokenManager()
    @State var foundToken: String? = nil
    @State var isTokenSaved: Bool = false
    
    @State var name: String = ""
    @State var surname: String = ""
    @State var phoneNumber: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            List{
                TextField("Enter name", text: $name)
                TextField("Enter surname", text: $surname)
                TextField("Enter phoneNumber", text: $phoneNumber)
            }.navigationTitle("New Contact").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print(name)
                            print(surname)
                            print(phoneNumber)
                            
//                            modelContext.insert(Contacts(name: name, surname: surname, phoneNumber: phoneNumber))
//                            dismiss()
                            
                            if let token = foundToken {
                                if let savedToken = tokenManager.savedToken {
                                    print("Token is already saved: \(savedToken)")
                                } else {
                                    tokenManager.saveToken(token)
                                    modelContext.insert(Contacts(name: name, surname: surname, phoneNumber: phoneNumber, token: token))
                                    dismiss()
                                }
                            } else {
                                print("Phone number not found")
                                
                            }
                        }) {
                            Text("Done")
                                .foregroundColor(.red)
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || surname.trimmingCharacters(in: .whitespaces).isEmpty||phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .toolbarBackground(.hidden)
                .onChange(of: phoneNumber) { newSearchText in
                    database.searchUserByPhoneNumber(phoneNumber: newSearchText) { fcmToken in
                        if let fcmToken = fcmToken {
                            foundToken = fcmToken
                        } else {
                            foundToken = nil
                        }
                        isTokenSaved = false
                    }
                }
            
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("This contact doesn't exist"),
                
                dismissButton: .default(
                    Text("Ok"),
                    action: {
                        showAlert.toggle()
                    }
                )
            )
        }
        
        
    }
}

//#Preview {
//    AddContact()
//}
