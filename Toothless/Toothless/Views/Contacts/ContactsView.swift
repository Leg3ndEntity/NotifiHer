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
    @State private var newContact = false
    @Query var userData: [Contacts] = []
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationView {
            List {
                ForEach(userData) { contact in
                    HStack {
                        Text("\(contact.name) \(contact.surname)")
                    }
                }
                .onDelete { indexSet in
                    deleteContacts(at: indexSet)
                }
            }
            .navigationTitle("Emergency contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        newContact.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.customRed)
                    }
                }
            }
        }
        .sheet(isPresented: $newContact) {
            AddContact()
        }
    }

    private func deleteContacts(at offsets: IndexSet) {
        // Delete contacts from the container
        for index in offsets {
            let contact = userData[index]
            modelContext.delete(contact)
        }

        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

#Preview {
    ContactsView()
        .modelContainer(for: Contacts.self, inMemory: true)
}
