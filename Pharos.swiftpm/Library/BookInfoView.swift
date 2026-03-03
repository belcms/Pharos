//
//  BookInfoView.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 19/02/26.
//

import SwiftUI
import SwiftData

struct BookInfoView: View {
    @State private var noteModalisPresented : Bool = false
    @State private var sessionsHistoryisPresented : Bool = false


    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @Environment(User.self) private var user: User
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var newBookModalisPresented: Bool = false
    @Namespace private var namespace
    
    @State var book: Book
    @Binding var path: NavigationPath


    var body: some View {
        if book.modelContext == nil {
            EmptyView()
        } else {
        
        ZStack(alignment: .top) {
            AppBackground().ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    VStack(spacing: 5) {
                        BookCoverView(isInfo: true, book: book)
                            .shadow(radius: 10)
                            .padding(.bottom)
                        
                        Text(book.title)
                            .font(.largeTitle.bold()).fontDesign(.serif)
                        
                        if let author = book.author {
                            Text(author)
                                .font(.callout)
                        }
                        
                        if let numberOfPages = book.numberOfPages {
                            Text(" \(numberOfPages) pages")
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
                        }

                        if let totalPages = book.numberOfPages {
                            BookProgressBar(
                                    currentPage: book.currentPage,
                                    totalPages: totalPages,
                                    bookColor: book.coverColor
                                )
                                .padding()
                        }

                        NavigationLink {
                            SessionView(book: book)
                        } label: {
                            Label("Read this book", systemImage: "books.vertical.fill")
                                .padding()
                                .background(Capsule().fill(.thinMaterial))
                        }
                        .buttonStyle(.plain)
                        .padding(.top)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                    .background {
                        
                        ZStack {
                            LinearGradient(
                                colors: [
                                    Color(book.coverColor),
                                    Color("Background")
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .padding(.top, -100)
                        .padding(.bottom, -400)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                            
                            SummaryComponent(book: book)
                            
                            if !book.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    
                                    Text("Notes")
                                        .font(.title3.weight(.semibold))
                                        .padding(.horizontal)
                                    
                                        ForEach(book.notes, id: \.persistentModelID) { note in
                                        if note.modelContext != nil {
                                            
                                            NavigationLink(destination: NoteModal(receivedNote: note, book: book, isNewNote: false, isEditing: false).navigationTransition(.zoom(sourceID: note.id, in: namespace))){
                                                noteFolderComponent(note: note).padding(.horizontal)
                                                    .matchedTransitionSource(id: note.id, in: namespace)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        
        .confirmationDialog(
            "Are you sure you want to delete this book?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                
                if user.lastBook == book {
                    user.lastBook = nil
                }
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    context.delete(book)
                    try? context.save()
                }
            }
            Button("Cancel", role: .cancel) {
                
            }
        } message: {
            Text("This action cannot be undone.")
        }
        
        .sheet(isPresented: $noteModalisPresented){
            NoteModal(book: book, isNewNote: true)
        }
        .sheet(isPresented: $sessionsHistoryisPresented){
            SessionsHistoryModal(book: book)
        }

        
        .sheet(isPresented: $newBookModalisPresented) {
            NewBookModal(existentBook: book)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section {
                        
                        Button {
                            sessionsHistoryisPresented = true
                        } label: {
                            Label("Session History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                        
                        Button {
                            noteModalisPresented = true
                        } label: {
                            Label("Add Note", systemImage: "note.text.badge.plus")
                        }
                        
                        Button {
                            newBookModalisPresented = true
                        } label: {
                            Label("Edit Book", systemImage: "pencil")
                        }
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete Book", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }        .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .navigationBar)
    }
    }
}

