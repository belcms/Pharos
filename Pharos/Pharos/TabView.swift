//
//  TabView.swift
//  Pharos
//
//  Created by Isabel Cristina Marras Salles on 17/05/26.
//

import SwiftUI

struct AppTabView: View {
    
    var body: some View {
        
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeScreen()
                }
                Tab("My Bookshelf", systemImage: "books.vertical.fill"){
                    BookshelfView()
                }
            }
    }
}

