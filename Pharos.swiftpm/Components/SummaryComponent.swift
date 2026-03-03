//
//  SummaryComponent.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 27/02/26.
//

import SwiftUI

struct SummaryComponent : View {
    var book: Book
    @State private var isExpanded: Bool = false
    
    
    var validSummaries: [String] {
        book.notes
            .map { $0.summary }
            .filter { !$0.isEmpty }
    }
    
    var body: some View {
        if !validSummaries.isEmpty {

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Key Takeaways")
                            .font(.headline)
                        Spacer()

                        Image(systemName: "sparkles")
                            .foregroundColor(Color(book.coverColor))
                    }
                    .padding(.bottom, 4)
                    
                    let displayItems = isExpanded ? validSummaries : Array(validSummaries.prefix(2))
                    
                    ForEach(displayItems, id: \.self) { summaryText in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "sparkle")
                                .foregroundColor(Color(book.coverColor))
                                .padding(.top, 3)
                            
                            Text(summaryText)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    if validSummaries.count > 2 {
                        Button {
                            withAnimation(.snappy) {
                                isExpanded.toggle()
                            }
                        } label: {
                            Text(isExpanded ? "Show Less" : "Show All \(validSummaries.count) Takeaways")
                                .font(.footnote.bold())
                                .foregroundColor(Color(book.coverColor))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 8)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            
        }
    }
}
