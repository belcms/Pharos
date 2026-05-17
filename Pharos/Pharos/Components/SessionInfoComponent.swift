//
//  SessionInfoComponent.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 28/02/26.
//

import SwiftUI
import SwiftData

struct SessionInfoComponent: View {

        var session: Session
        
        private func formatDuration(_ duration: TimeInterval) -> String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = duration >= 3600 ? [.hour, .minute] : [.minute, .second]
            formatter.unitsStyle = .abbreviated
            return formatter.string(from: duration) ?? "0m"
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Label(formatDuration(session.duration), systemImage: "clock.fill")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let pages = session.pagesRead, pages > 0 {
                        Label("\(pages) pgs", systemImage: "book.pages.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                Text(session.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial) 
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
