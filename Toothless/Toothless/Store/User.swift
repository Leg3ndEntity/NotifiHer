//
//  User.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {
    var name: String
    var surname: String
    var phoneNumber: String
    var fcmToken: String
    
    init(name: String, surname: String, phoneNumber: String, fcmToken: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.fcmToken = fcmToken
    }
}
