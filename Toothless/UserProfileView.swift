//
//  UserProfileView.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        NavigationView{
            VStack{
                Circle()
                Text("Nome Cognome")
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    UserProfileView()
}
