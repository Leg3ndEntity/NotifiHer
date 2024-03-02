//
//  ContactsView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 02/03/24.
//
import Foundation
import SwiftUI
import SwiftData

struct ContactManager {
    static let shared = ContactManager()
    
    @Environment(\.modelContext) var modelContext: ModelContext
    // Function to add a contact
    func addContact(name: String, surname: String, phoneNumber: String, fcmToken: String) {
        modelContext.insert(Contacts(name: name, surname: surname, phoneNumber: phoneNumber))
    }
}

struct ContactsView: View {
    @State var newContact: Bool = false
    @State var userData: [Contacts] = []
    
    var body: some View {
        NavigationView{
            
            List{
                ForEach(userData) { contact in
                    VStack(alignment: .leading) {
                        Text("Name: \(contact.name)")
                        Text("Surname: \(contact.surname)")
                        Text("Phone Number: \(contact.phoneNumber)")
                        // Text("FCM Token: \(contact.fcmToken)")
                    }
                }
            }.navigationTitle("Emergency contacts")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem{
                        Button{
                            newContact.toggle()
                        }label:{
                            Image(systemName: "plus")
                                .foregroundColor(.customRed)
                        }
                    }
                }
            
        }.sheet(isPresented: $newContact, content: {
            AddContact()
        })
    }
}

#Preview {
    ContactsView()
}
