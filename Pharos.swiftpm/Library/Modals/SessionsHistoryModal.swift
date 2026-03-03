//
//  SessionsHistoryModal.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 28/02/26.
//

import SwiftUI
import SwiftData

struct SessionsHistoryModal: View {
    @Environment(\.dismiss) var dismiss
    var book: Book
    
    var sortedSessions: [Session] {
        book.sessions.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                if sortedSessions.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.badge.xmark")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No reading sessions yet.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(sortedSessions) { session in
                                SessionInfoComponent(session: session)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Session History")
            .navigationBarTitleDisplayMode(.inline)
             .toolbar {
                 ToolbarItem(placement: .topBarTrailing) {
                     Button(role: .close){
                         dismiss()
                     } label: {
                         Label("Close", systemImage: "xmark")
                     }
                    
                 }
             }

        }
    }
}
