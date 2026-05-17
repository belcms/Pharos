//
//  PharosApp.swift
//  Pharos
//
//  Created by Isabel Cristina Marras Salles on 17/05/26.
//

import SwiftUI
import SwiftData

@main
struct PharosApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [User.self,Book.self, Note.self, Session.self])
    }
}
