//
//  User.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import Foundation
import SwiftData

@Model class User {
    var name: String
    var surname: String
    var phoneNumber: String
    
    init(name: String, surname: String, phoneNumber: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
    }
}
