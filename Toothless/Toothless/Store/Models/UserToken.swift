//
//  UserToken.swift
//  Toothless
//
//  Created by Simone Sarnataro on 02/03/24.
//

import Foundation
import SwiftData

@Model
final class UserToken: Identifiable {
    var fcmToken: String?
    
    init(fcmToken: String?) {
        self.fcmToken = fcmToken
    }
}
