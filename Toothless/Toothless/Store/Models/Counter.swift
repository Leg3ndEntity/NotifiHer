//
//  Counter.swift
//  Toothless
//
//  Created by Simone Sarnataro on 06/03/24.
//

import Foundation
import SwiftData

@Model class Counter{
    var counter: Int = 180
    
    init(counter: Int) {
        self.counter = counter
    }
}
