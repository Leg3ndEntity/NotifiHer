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
        Page(name: "Welcome to Yuri App!", description: "The best app to help you in times of danger.", imageUrl: "", tag: 0),
        Page(name: "Activate the button!", description: "Get help from your trusted people.", imageUrl: "", tag: 1),
        Page(name: "Use our fantastic tools!", description: "In case you need them, you can count on many tools to feel safer.", imageUrl: "", tag: 2),
    ]
}
