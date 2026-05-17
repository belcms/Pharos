//
//  LastBookCard.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 25/02/26.
//

import SwiftUI

struct LastBookCard: View {
    var book: Book
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Last Book")
                .font(.title2.weight(.semibold))
            NavigationLink {
                BookInfoView(book: book, path: $path)
            } label: {
                VStack{
                    HStack {
                        BookCoverView(book: book)
                        VStack(alignment: .leading){
                            Text(book.title)
                                .font(.body)
                                .bold(true)
                                .lineLimit(2)
                                .padding(.leading)

                            Text(book.author ?? "")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.leading)

                            Spacer()
                            
                            if let totalPages = book.numberOfPages {
                                BookProgressBar(
                                        currentPage: book.currentPage,
                                        totalPages: totalPages,
                                        bookColor: book.coverColor
                                    )
                                    .padding(.top, 5)
                            }
                        }
                        .frame(height: 142)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    } .padding(.vertical)
                    
                }
                .padding()
                .background(.ultraThinMaterial)
                .background(Color(book.coverColor).opacity(0.3))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            
        }
        .padding()
    }
}


