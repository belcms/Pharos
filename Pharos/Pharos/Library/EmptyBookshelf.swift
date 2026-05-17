//
//  EmptyBookshelf.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 28/02/26.
//

import SwiftUI

struct EmptyBookshelfView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 60))
                .foregroundStyle(.quaternary)
                .padding(.bottom, 8)
            
            Text("A new chapter awaits")
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            Text("Tap the + to add your first book and begin your reading journey.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
