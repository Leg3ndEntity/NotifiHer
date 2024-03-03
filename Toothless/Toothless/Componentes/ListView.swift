//
//  ListView.swift
//  Toothless
//
//  Created by Andrea Romano on 01/03/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var Database: Database
    var body: some View {
        NavigationStack {
            List(Database.utenti, id: \.id) { utenti in
                Text(utenti.name)
            }
        }
    }
}
