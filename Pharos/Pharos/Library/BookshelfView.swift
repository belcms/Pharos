//
//  Bookshelf.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 17/02/26.
//

import SwiftUI
import SwiftData

struct BookshelfView: View {
    @State private var searchText = ""
    
    @Environment(User.self) private var user: User
    @Environment(\.modelContext) private var context

    @State private var path = NavigationPath()
    
    @State private var showDeleteConfirmation = false
    @State private var bookToDelete: Book? = nil
    
    @State private var newBookModalisPresented : Bool = false
    @Query private var books: [Book]
    
    @State private var bookToEdit: Book? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                AppBackground()
                
                if books.isEmpty {
                    EmptyBookshelfView()
                } else {
                    
                    ScrollView{
                        LazyVGrid(columns: columns){
                            ForEach(books) { book in
                                VStack{
                                    
                                    NavigationLink(destination: BookInfoView(book: book, path: $path)){
                                        BookCoverView(isBookshelf: true, book: book)
                                    }.buttonStyle(.plain)
                                    
                                    
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

            .navigationTitle(Text("My Bookshelf"))
           .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        bookToEdit = nil
                        newBookModalisPresented = true
                    } label: {
                        Label("Add new book", systemImage: "plus")
                    }
                }
            }
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

