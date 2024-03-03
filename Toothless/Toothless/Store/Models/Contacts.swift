//
//  Contacts.swift
//  Toothless
//
//  Created by Simone Sarnataro on 02/03/24.
//

import Foundation
import SwiftData

@Model
final class Contacts{
    var name: String
    var surname: String
    var phoneNumber: String
    var token: String?
    
    init(name: String, surname: String, phoneNumber: String, token: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.token = token
    }
}
