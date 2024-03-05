//
//  PageModel.swift
//  Toothless
//
//  Created by Andrea Romano on 22/02/24.
//

import Foundation
import ImageIO

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String?
    var description: String?
    var gif: String?
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", gif: "work", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: NSLocalizedString("Activate the Panic button!", comment: ""), description: NSLocalizedString("In case of necessity, tap the button to send an alert to your emergency contacts.", comment: ""), gif: "tap", tag: 0),
        Page(name: NSLocalizedString("Start the timer!", comment: ""), description: NSLocalizedString("If you feel a sense of danger, hold the button to start a timer. When it ends, your emergency contacts will be notified.", comment: ""), gif: "hold", tag: 1),
        Page(name: NSLocalizedString("Visualize safe spots!", comment: ""), description: NSLocalizedString("Open the map from the bottom sheet to see all the safe spots sorrounding your position.", comment: ""), gif: "map", tag: 2),
        Page(tag: 3)
    ]
}
