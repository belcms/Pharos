//
//  UserModel.swift
//  Pharos
//
//  Created by Isabel Cristina Marras Salles on 17/05/26.
//

import SwiftData

@Model
class User {
    var lastBook: Book?
    
    init(){
        lastBook = nil
    }
    
}
