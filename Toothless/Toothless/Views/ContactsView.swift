//
//  ContactsView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 02/03/24.
//
import Foundation
import SwiftUI
import SwiftData

struct ContactsView: View {
    @State var newContact: Bool = false
    @State var userData: [Contacts] = []
    @State var fatto: Bool = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView{
            
            List{
                ForEach(userData) { contact in
                    HStack(){
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
            AddContact(fatto: $fatto)
        })
    }
}

#Preview {
    ContactsView()
        .modelContainer(for: Contacts.self, inMemory: true)
}
