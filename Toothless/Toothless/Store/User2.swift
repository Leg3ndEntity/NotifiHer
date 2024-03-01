//
//  User2.swift
//  Toothless
//
//  Created by Andrea Romano on 01/03/24.
//

import Foundation
import SwiftData

class User2: Identifiable, Codable {
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
