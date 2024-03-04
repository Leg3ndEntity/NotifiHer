//
//  FakeCalls.swift
//  Toothless
//
//  Created by Alessia Previdente on 04/03/24.
//

import Foundation
struct FakeCall : Identifiable{
    var id: UUID = UUID()
    var situation: String
    var duration: String
    var imagename: String
    var video: String
}
