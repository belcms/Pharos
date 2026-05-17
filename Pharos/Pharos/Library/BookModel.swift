//
//  BookModel.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 11/02/26.
//

import SwiftData
import Foundation

@Model
class Book {
    public var title: String
    public var author: String?
    public var numberOfPages: Int?
    public var coverColor: String
    public var currentPage: Int
    

    @Relationship(deleteRule: .cascade, inverse: \Session.book) var sessions: [Session]
    @Relationship(deleteRule: .cascade, inverse: \Note.book) var notes: [Note]

    
    init(title: String, author: String? = nil, numberOfPages: Int? = nil, coverColor: String = "Color2", currentPage: Int = 0){
        self.title = title
        self.sessions = []
        self.author = author
        self.numberOfPages = numberOfPages
        self.notes = []
        self.coverColor = coverColor
        self.currentPage = currentPage
    }
    
    
}
