//
//  PageInputModal.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 27/02/26.
//

import SwiftUI


struct PageInputModal: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var pageNumber: String = ""
    var session: Session
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("What page are you on now?")
                    .font(.title3.bold())
                    .padding(.top)
                
                VStack(spacing: 8) {
                    TextField("0", text: $pageNumber)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .focused($isTextFieldFocused)
                    
                    Text("CURRENT PAGE")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                        .tracking(1)
                }
                .padding(.vertical, 20)
                
                
                Button {
                    if let newPage = Int(pageNumber) {
                        let pagesReadThisSession = newPage - session.book.currentPage
                        
                        session.pagesRead = max(0, pagesReadThisSession)
                        
                        session.book.currentPage = newPage
                        
                    }
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    }
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(16)
                }
                .disabled(pageNumber.isEmpty) 
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            
                        }
                    }
                }
            }
        }
    }
}
