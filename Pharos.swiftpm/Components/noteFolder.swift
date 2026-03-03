//
//  noteFolder.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 19/02/26.
//

import SwiftUI

struct noteFolderComponent: View {
    @State private var noteModalisPresented : Bool = false
    @State private var showDeleteConfirmation: Bool = false

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @Namespace private var namespace

    @State var note: Note
    
    var body: some View{
        VStack(alignment: .leading){
            if let title = note.title {
                if title != "" {
                    Text(title).bold(true)
                }
            }

            Text(note.text)
                .lineLimit(4)
            Divider()
            HStack{
                Text(note.date.formatted(.dateTime.day().month().year()))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                
                
                Menu {
                    
                    Button {
                        noteModalisPresented = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                            .matchedTransitionSource(id: note.id, in: namespace)
                    }

                    Divider()
                    
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                        .contentShape(Rectangle()) 
                                        .padding(.vertical, 5)
                }
            }
        }
        .sheet(isPresented: $noteModalisPresented){
            NoteModal(receivedNote: note, book: note.book, isNewNote: true, isEditing: true)
        }
        
        .confirmationDialog(
            "Are you sure you want to delete this note?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {Button("Delete", role: .destructive) {
                context.delete(note)
                try? context.save()
                dismiss()
                }
            
            Button("Cancel", role: .cancel) {
                
            }
        } message: {
            Text("This action cannot be undone.")
        }
        
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
