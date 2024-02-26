//
//  PageModel.swift
//  Toothless
//
//  Created by Andrea Romano on 22/02/24.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "Activate the Panic button!", description: "Premi", imageUrl: "", tag: 0),
        Page(name: "Start the timer!", description: "Tieni premuto", imageUrl: "", tag: 1),
        Page(name: "Visualize safe spots", description: "Apri la mappa dalla modale", imageUrl: "", tag: 2),
        Page(name: "Live Reports", description: "Visualizza posti non sicuri", imageUrl: "", tag: 3),
        Page(name: "Fake Calls", description: " chiamate finte cu patt", imageUrl: "", tag: 4),
        Page(name: "Walkie talkie", description: "parla direttamente con mamm't (negazione inglese)", imageUrl: "", tag: 5)
    ]
}
