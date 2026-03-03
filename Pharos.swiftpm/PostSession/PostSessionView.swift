//
//  PostSessionView.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 27/02/26.
//

import SwiftUI

struct PostSessionView : View {
    @Environment(\.dismiss) var dismiss
    var dismissParent: DismissAction
    
    @State private var showPageInputModal = true
    @State private var noteModalisPresented : Bool = false


    @State private var appeared = false
    @State private var pageStopped: String = ""
    
    var session: Session
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            AppBackground()
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                VStack(spacing: 24) {
                    

                    
                    VStack(spacing: 10) {
                        Text("You read for")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Text(
                            session.duration.asDuration
                                .formatted(.units(
                                    allowed: [.hours, .minutes, .seconds],
                                    width: .narrow
                                ))
                        )
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                    }
                    
                
                    Image("CatAndBooks")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .scaleEffect(appeared ? 1 : 0.9)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.6), value: appeared)
                    
                    if let pages = session.pagesRead, pages > 0 {
                        HStack(spacing: 4) {
                            Text("\(pages)")
                                .font(.largeTitle).fontWeight(.semibold)
                            Text("pages explored")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button {
                        noteModalisPresented = true
                    } label: {
                        Label("Reflect on this moment", systemImage: "sparkles")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(16)
                    }
                    
                    Button {
                        dismiss()
                        dismissParent()
                    } label: {
                        Text("Close the book")
                            .font(.subheadline.bold())
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .fullScreenCover(isPresented: $noteModalisPresented){
                NoteModal(session: session, book: session.book, isNewNote: true)
            }

            .onAppear {
                appeared = true
            }
        }
        .sheet(isPresented: $showPageInputModal) {
            PageInputModal(session: session)
                .presentationDetents([.fraction(0.4)]) 
        }
    }
}
