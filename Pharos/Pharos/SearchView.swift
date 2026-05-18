//
//  SearchView.swift
//  Pharos
//
//  Created by Isabel Cristina Marras Salles on 17/05/26.
//

import SwiftUI
import SwiftData
import Combine

struct SearchView: View {
    var books: [Book] = []
    @State private var searchText = ""

    
    @Environment(User.self) private var user: User
    @Environment(\.modelContext) private var context

    @State private var path = NavigationPath()
    
    @State private var showDeleteConfirmation = false
    @State private var bookToDelete: Book? = nil
    
    @State private var newBookModalisPresented : Bool = false
//    @Query(sort: \Book.creationDate, order: .reverse) private var books: [Book]
    
    @State private var bookToEdit: Book? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var searchResults: [Book] {
            if searchText.isEmpty {
                return []
            } else {
                return books.filter { book in
                    let matchTitle = book.title.localizedCaseInsensitiveContains(searchText)
                    let matchAuthor = (book.author ?? "").localizedCaseInsensitiveContains(searchText)
                    return matchTitle || matchAuthor
                }
            }
        }

    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                AppBackground()
                
                if searchText.isEmpty {
                    ContentUnavailableView("Search for your next read by name or author", systemImage: "book")
                }
                else if searchResults.isEmpty {
                    ContentUnavailableView("No results found", systemImage: "book")
                } else {
                    
                    ScrollView{
                        LazyVGrid(columns: columns){
                            ForEach(searchResults) { book in
                                VStack{
                                    
                                    NavigationLink(destination: BookInfoView(book: book, path: $path)){
                                        BookCoverView(isBookshelf: true, book: book)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    HStack {
                                        Text(book.title)
                                            .font(.subheadline).fontWeight(.semibold)
                                            .foregroundStyle(Color(.label))
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        
                                        Spacer()
                                        
                                        Menu {
                                            
                                            Button {
                                                bookToEdit = book
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            
                                            Divider()
                                            Button(role: .destructive) {
                                                bookToDelete = book
                                                showDeleteConfirmation = true
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            
                                            
                                            
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .font(.system(size: 16))
                                                .foregroundColor(.secondary)
                                                .contentShape(Rectangle())
                                                .padding(.vertical, 5)
                                        }
                                        
                                    }
                                    .frame(width: 110 * 1.25)
                                    
                                }.padding()
                            }
                        }
                        .padding()
                    }
                }
            }

            .navigationTitle("Search")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "type here to search"
            )


        }.confirmationDialog(
            "Are you sure you want to delete this book?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                
                if let bookToDelete = bookToDelete {
                    deleteBook(bookToDelete)
                }
            }
            Button("Cancel", role: .cancel) {
                bookToDelete = nil
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(item: $bookToEdit) { book in
            NewBookModal(existentBook: book)
        }
        .sheet(isPresented: $newBookModalisPresented) {
            NewBookModal()
        }
    }
    
    func deleteBook(_ book: Book){
        
        if user.lastBook == book {
            user.lastBook = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            context.delete(book)
            try? context.save()
        }

    }
}

