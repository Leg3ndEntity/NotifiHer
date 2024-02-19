//
//  AccountView.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                
                List{
                    Section{
                        VStack(alignment: .center){
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 75, height: 75)
                            HStack {
                                Spacer()
                                Text("nome cognome")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                    }.listRowBackground(Color.clear)
                    Section{
                        NavigationLink {
                            //DetailsView()
                        } label: {
                            Text("Health Details")
                        }
                        Text("...")
                    }
                    Section(header: Text("Features").font(.title3).fontWeight(.bold)){
                        Text("Checklist")
                        Text("Apps and services")
                        Text("Devices")
                    }
                    Section(header: Text("Setting").font(.title3).fontWeight(.bold)){
                        Text("...")
                        Text("Notifications")
                    }
                }
                .toolbar(content: {
                    ToolbarItem{
                        Button{
                            dismiss()
                        }label:{
                            Text("Done")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                        }
                    }
                })
                
                
            }
        }//.preferredColorScheme(.dark)
    }
}

#Preview {
    UserProfileView()
}
