//
//  AddContact.swift
//  Toothless
//
//  Created by Simone Sarnataro on 02/03/24.
//

import SwiftUI

struct AddContact: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State  var name: String = ""
    @State  var surname: String = ""
    @State  var phoneNumber: String = ""
    
    @Binding var fatto: Bool
    var body: some View {
        NavigationStack{
            List{
                TextField("Enter name", text: $name)
                TextField("Enter surname", text: $surname)
                TextField("Enter phoneNumber", text: $phoneNumber)
            }.navigationTitle("New Contact").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .foregroundColor(.customRed)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            modelContext.insert(Contacts(name: name, surname: surname, phoneNumber: phoneNumber))
                            fatto = true
                            dismiss()
                            
                        }) {
                            Text("Done")
                                .foregroundColor(.customRed)
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || surname.trimmingCharacters(in: .whitespaces).isEmpty||phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .toolbarBackground(.hidden)
        }


    }
}

//#Preview {
//    AddContact()
//}
