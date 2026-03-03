//
//  homeTeste.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 11/02/26.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @State private var newBookModalisPresented : Bool = false
    @Query(sort: \Session.date, order: .reverse) private var allSessions: [Session]
    @Query private var allBooks: [Book]
    
    @State private var path = NavigationPath()
    
    
    var lastReadBook: Book? {
            allSessions.first?.book
        }
    
    
    var secondsReadToday: TimeInterval {
        let today = Calendar.current.startOfDay(for: .now)
        return allSessions
            .filter { $0.date >= today }
            .reduce(0) { $0 + $1.duration }
    }
    
    var pagesReadThisWeek: Int {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        return allSessions
            .filter { $0.date >= sevenDaysAgo }
            .reduce(0) { $0 + ($1.pagesRead ?? 0) }
    }
        
    var carouselBooks: [Book] {
        if let lastBook = lastReadBook {
            return allBooks.filter { $0 != lastBook }
        }
        return allBooks
    }

    
    func formatTime(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: seconds) ?? "0m"
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                AppBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        if allBooks.isEmpty {
                            NoBookReadView()
                        } else {
                            

                            if let lastBook = lastReadBook {
                                LastBookCard(book: lastBook, path: $path)
                                
                                HStack(spacing: 12) {
                                    StatBox(
                                        title: "Time Today",
                                        value: formatTime(secondsReadToday),
                                        icon: "clock.badge.checkmark",
                                        color: .primary
                                    )
                                    
                                    StatBox(
                                        title: "Pages this week",
                                        value: "\(pagesReadThisWeek) pgs",
                                        icon: "book.pages",
                                        color: .primary
                                    )
                                }
                                .padding(.horizontal)
                            }
                            
                            if !carouselBooks.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Pick up your next read")
                                        .font(.title3.bold())
                                        .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(carouselBooks) { book in
                                                VStack(spacing: 8) {
                                                    
                                                    NavigationLink(destination: SessionView(book: book)) {
                                                        BookCoverView(book: book)
                                                    }
                                                    .buttonStyle(.plain)
                                                    
                                                    Text(book.title)
                                                        .font(.subheadline).fontWeight(.semibold)
                                                        .foregroundStyle(Color(.label))
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                }
                                                .frame(width: 110)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 40)
                }
            }
//            .navigationTitle("Home")
            .toolbar{
                 ToolbarItem(placement: .navigationBarTrailing){
                     Button {
                         newBookModalisPresented = true
                     } label: {
                         Label("Add new book", systemImage: "plus")
                     }
                 }
             }

        }
        .sheet(isPresented: $newBookModalisPresented) {
            NewBookModal()
        }
    }
}



struct NoBookReadView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image("CatLookingFoward")
                .resizable()
                .scaledToFit()
                .opacity(0.8)
                .frame(width: 150)
            
            VStack(spacing: 8) {
                Text("Your journey starts here")
                    .font(.title3.bold())
                    .fontDesign(.serif)
                
                Text("Tap the + above to add a book and begin your reading journey.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Spacer()
            Spacer()
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.footnote).fontWeight(.semibold)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.subheadline).fontWeight(.semibold)

            }
            
            Text(value)
                .font(.title2).fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                )
        )
    }
}

