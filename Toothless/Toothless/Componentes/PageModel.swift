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
    var image: String?
    var tag: Int

    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", gif: "work", tag: 0)

    static var samplePages: [Page] = [
        Page(name: "Activate the Panic button!", description: "In case of necessity, tap the button to send an alert to your emergency contacts.", gif: "sfondo1", tag: 0),
        Page(name: "Start the timer!", description: "If you feel a sense of danger, hold the button to start a timer. When it ends, your emergency contacts will be notified.", gif: "sfondo2", tag: 1),
        Page(name: "Discover all the features!", description: "Swipe up to see all the available services that may help you in case of danger", gif: "sfondo31", tag: 2)
    ]
}
