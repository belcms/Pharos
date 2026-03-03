//
//  SessionModel.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 11/02/26.
//

import SwiftData
import Foundation

@Model
class Session {
    var book: Book
    var date: Date
    var duration: TimeInterval
    var pagesRead: Int?
    @Relationship(deleteRule: .cascade, inverse: \Note.session) var notes: [Note]
    
    init(book: Book, date: Date, duration: TimeInterval = 0) {
        self.book = book
        self.date = date
        self.notes = []
        self.duration = duration
    }
}
