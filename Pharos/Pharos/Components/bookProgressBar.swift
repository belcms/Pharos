//
//  bookProgressBar.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 28/02/26.
//

import SwiftUI

struct BookProgressBar: View {
    var currentPage: Int
    var totalPages: Int
    var bookColor: String
    
    private var progress: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }
    
    private var percentageString: String {
        let percent = Int(progress * 100)
        let value = min(100, percent)
        return "\(value)%"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.primary.opacity(0.1))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(Color(bookColor).gradient)
                        .frame(width: geo.size.width * CGFloat(progress), height: 8)
                }
                .padding(.leading)
            }
            .frame(height: 8) 
            
            HStack {
                Text("\(currentPage)/\(totalPages) pages")
                Spacer()
                Text(percentageString)
                    .font(.caption2.bold())
                    .monospacedDigit()
                    .padding(.leading)
            }
            .padding(.leading)
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }
}
