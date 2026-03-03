//
//  RootView.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 24/02/26.
//

import SwiftUI
import SwiftData
struct RootView: View {
    
    @Query private var users: [User]
    @Environment(\.modelContext) private var context
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    
    var body: some View {
        Group {
            if hasOnboarded {
                if let user = users.first {
                    AppTabView()
                        .environment(user)
                    
                    
                } else {
                    ProgressView()
                        .task {
                            await seedMockData(context: context)
                                        }
                                }
//                } else {
//                    ProgressView()
//                        .task {
//                            let newUser = User()
//                            context.insert(newUser)
//                        }
//                }
            } else {
                OnboardingView()
            }
        }
        .animation(.default, value: hasOnboarded)
    }
    
    
    @MainActor
    func seedMockData(context: ModelContext) async  {
        let descriptor = FetchDescriptor<Book>()
        let existingBooks = (try? context.fetch(descriptor)) ?? []
        
        guard existingBooks.isEmpty else { return }
        
        let mockUser = User()
        context.insert(mockUser)
        
        let book1 = Book(title: "Moby-Dick", author: "Herman Melville", numberOfPages: 648, coverColor: "Color2", currentPage: 45)
        let book2 = Book(title: "Pride and Prejudice", author: "Jane Austen", numberOfPages: 88, coverColor: "Color6", currentPage: 24)
        let book3 = Book(title: "Dracula", author: "Bram Stoker", numberOfPages: 554, coverColor: "Color5", currentPage: 328)
        
        context.insert(book1)
        context.insert(book2)
        context.insert(book3)
        

        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let session1 = Session(book: book1, date: yesterday, duration: 1800)
        session1.pagesRead = 20
        context.insert(session1)
        
        let session2 = Session(book: book2, date: .now, duration: 2700)
        session2.pagesRead = 14
        context.insert(session2)

                
                let note1 = Note(
                    session: session1,
                    book: book1,
                    text: "Ahab's obsession with the white whale is terrifying, but the way Melville describes the sea leaves me completely immersed. This 30-minute break flew by.",
                    title: "Immersed in the Sea",
                    date: yesterday
                )
                
                let note2 = Note(
                    session: session2,
                    book: book2,
                    text: "Jane Austen's humor and irony are brilliant. It's fascinating how the social dynamics of that era still resonate today. Great session to clear my mind.",
                    title: "Timeless Irony",
                    date: .now
                )
                
                let note3 = Note(
                            session: nil,
                            book: book3,
                            text: "The gothic horror atmosphere at the castle in these early chapters is unmatched. The suspense is really pulling me in, I can't wait to see what happens next.",
                            title: "Castle Shadows",
                            date: .now
                        )
                
                
                context.insert(note1)
                context.insert(note2)
                context.insert(note3)
        
        do {
                    try await note1.summarizeNote()
                    try await note2.summarizeNote()
                    try await note3.summarizeNote()
                } catch {
                    print("Erro ao gerar resumo no mock: \(error)")
                }
        
        try? context.save()
        

    }
    
}
