//
//  NoteModal.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 12/02/26.
//


//arrumarrrrrr

import SwiftUI
import Foundation
import Speech
import AVFoundation


struct NoteModal: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var session: Session?
    var book: Book
    var receivedNote: Note?
    var isNewNote: Bool
    
    @State private var isEditing: Bool
    @State private var showDeleteConfirmation: Bool = false
    @State private var isGeneratingTitle: Bool = false
    
    @State private var title: String = ""
    @State private var textNote: String = ""
    
    init(session: Session? = nil, receivedNote: Note? = nil, book: Book, isNewNote: Bool, isEditing: Bool = false) {
        self.session = session
        self.receivedNote = receivedNote
        self.book = book
        self.isNewNote = isNewNote
        self._isEditing = State(initialValue: receivedNote == nil || isEditing)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if isEditing {
                        TextField("Title", text: $title, axis: .vertical)
                            .textFieldStyle(.plain)
                            .fontWeight(.bold)
                        
                        Button {
                            generateTitle()
                        } label: {
                            Image(systemName: "wand.and.sparkles")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    } else {
                        if !title.isEmpty {
                            Text(title)
                                .padding(.bottom, 1.8)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)

                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                if !(isEditing == false && title.isEmpty){
                    Divider()
                        .padding(.horizontal)
                }

                ZStack(alignment: .topLeading) {
                    if isEditing {
                        TextEditor(text: $textNote)
                            .padding(.top, -8)
                            .padding(.leading, -5)
                        
                        if textNote.isEmpty {
                            Text("Write about what are you thinking...")
                                .foregroundColor(.secondary)
                        }
                    } else {
                        ScrollView {
                            Text(textNote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.vertical)
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle(isNewNote ? "New note" : "")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if isNewNote {
                        Button(action: {
                            if isNewNote {
                                dismiss()
                            } else {
                                title = receivedNote?.title ?? ""
                                textNote = receivedNote?.text ?? ""
                                isEditing = false
                            }
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if isEditing {
                        Button(action: saveNote) {
                            Image(systemName: isGeneratingTitle ? "progress.indicator" : "checkmark")
                        }
                        .buttonStyle(.glassProminent)
                        .disabled(textNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isGeneratingTitle)
                    } else {
                        HStack {
                            Menu {
                                Button(role: .destructive) {
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.secondary)
                            }
                            
                            Button {
                                isEditing = true
                            } label: {
                                Text("Edit")
                            }
                        }
                    }
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete this note?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    deleteNote()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
            .onAppear {
                if let receivedNote = receivedNote {
                    self.textNote = receivedNote.text
                    self.title = receivedNote.title ?? ""
                }
            }
        }
    }
    
    
    private func saveNote() {
        let finalNote = receivedNote ?? Note(session: session, book: book, text: textNote, date: .now)
        finalNote.text = textNote
        
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            Task {
                await generateTitleAsync(for: finalNote)
                finalizeSave(note: finalNote)
            }
        } else {
            finalNote.title = title
            finalizeSave(note: finalNote)
        }
    }
    
    private func finalizeSave(note: Note) {
        if receivedNote == nil {
            context.insert(note)
        }
        
        Task {
            do {
                try await note.summarizeNote()
            } catch {
                print("Summarize error: \(error)")
            }
        }
        
        try? context.save()
        
        if isNewNote {
            dismiss()
        } else {
            isEditing = false
        }
    }
    
    private func deleteNote() {
        if let receivedNote = receivedNote {
            context.delete(receivedNote)
            try? context.save()
        }
        dismiss()
    }
    
    private func generateTitle() {
        let tempNote = receivedNote ?? Note(session: session, book: book, text: textNote, date: .now)
        Task {
            await generateTitleAsync(for: tempNote)
        }
    }
    
    @MainActor
    private func generateTitleAsync(for note: Note) async {
        isGeneratingTitle = true
        defer { isGeneratingTitle = false }
        
        do {
            if let titleModel = try await note.suggestedTitle(currentText: textNote) {
                await MainActor.run {
                    note.title = titleModel
                    self.title = titleModel
                }
            }
        } catch {
            print("Error in generating title: \(error)")
        }
    }
}


