//
//  TabView.swift
//  Pharos
//
//  Created by Isabel Cristina Marras Salles on 17/05/26.
//

import SwiftUI
import SwiftData

struct AppTabView: View {
    @Query(sort: \Book.creationDate, order: .reverse) private var books: [Book]
    
    var body: some View {
        
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeScreen()
                }
                Tab("My Bookshelf", systemImage: "books.vertical.fill"){
                    BookshelfView()
                }
                Tab(role: .search){
                   SearchView(books: books)
                }
            }
    }
}

