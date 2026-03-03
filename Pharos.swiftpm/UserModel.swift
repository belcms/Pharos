//
//  UserModel.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 24/02/26.
//

import SwiftData

@Model
class User {
    var lastBook: Book?
    
    init(){
        lastBook = nil
    }
    
}
