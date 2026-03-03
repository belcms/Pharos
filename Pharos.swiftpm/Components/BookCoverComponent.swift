//
//  BookCoverComponent.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 25/02/26.
//


import SwiftUI

struct BookCoverView: View {
    @State var isInfo: Bool = false
    @State var isBookshelf: Bool = false
    var book: Book
    
    var body: some View {
        
        let scale = isBookshelf ? 1.25 : (isInfo ? 1.5 : 1)
        
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color("Paper"))
                .frame(width: 110 * scale, height: 152 * scale)
                .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                .offset(y: 3 * scale)
            
            ZStack(alignment: .topLeading) {
                
                Rectangle()
                    .fill(Color(book.coverColor))
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])

                Rectangle()
                    .fill(Color(book.coverColor)).brightness(-0.1)
                    .frame(width: 10 * scale)
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.system(isInfo ? .headline : .caption, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.7)
                }
                .padding(.leading, 20 * scale)
                .padding(.trailing, 8 * scale)
                .padding(.top, 12 * scale)
            }
            .frame(width: 110 * scale, height: 152 * scale)
            .clipped()
        }
    }
}
