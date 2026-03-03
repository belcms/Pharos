//
//  NewBookModal.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 17/02/26.
//

import SwiftUI
import SwiftData

struct NewBookModal: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    var existentBook: Book?
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var numberOfPages: Int?
    @State private var selectedColor: String = "Color2"
    
    let availableColors: [String] = [
        "Color2",
        "Color3",
        "Color4",
        "Color5",
        "Color6"
    ]
    
    init(existentBook: Book? = nil) {
        self.existentBook = existentBook
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Cover(title: title, coverColor: selectedColor)
                    .padding(.top)
                
                List {
                    Section {
                        TextField("Title", text: $title)
                        TextField("Author", text: $author)
                        TextField("Number of pages", value: $numberOfPages, format: .number)
                            .keyboardType(.numberPad)
                    }
                    Section("Cover Color") {
                        ColorPickerRow(
                            availableColors: availableColors,
                            selectedColor: $selectedColor
                        )
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(existentBook != nil ? Text(existentBook!.title) : Text("New Book"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: saveBook) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear(){
            if let existentBook = existentBook {
                title = existentBook.title
                if let author = existentBook.author {
                    self.author = author
                }
                numberOfPages = existentBook.numberOfPages
                selectedColor = existentBook.coverColor
            }
        }
    }
    
    private func saveBook() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespaces)
        let cleanedAuthor = author.trimmingCharacters(in: .whitespaces)
        
        
        if let existentBook = existentBook{
            existentBook.title = cleanedTitle
            existentBook.author = cleanedAuthor.isEmpty ? nil : cleanedAuthor
            existentBook.numberOfPages = numberOfPages
            existentBook.coverColor = selectedColor
        } else {
            let newBook = Book(
                title: cleanedTitle,
                author: cleanedAuthor.isEmpty ? nil : cleanedAuthor,
                numberOfPages: numberOfPages,
                coverColor: selectedColor
            )
            
            context.insert(newBook)
        }

        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
        dismiss()
    }
}

private struct ColorPickerRow: View {
    let availableColors: [String]
    @Binding var selectedColor: String
    
    var body: some View {
        HStack {
            ForEach(availableColors, id: \.self) { colorName in
                Circle()
                    .fill(Color(colorName))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(selectedColor == colorName ? Color.secondary : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedColor = colorName
                    }
            }
        }
    }
}

struct Cover : View {
    var title: String
    var coverColor: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("Paper"))
                .frame(width: 110 , height: 152)
                .offset(y: 5)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(coverColor))
                
                Rectangle()
                    .fill(Color(coverColor)).brightness(-0.1)
                    .frame(width: 10)
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(.caption, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.7)
                }
                .padding(.leading, 15)
                .padding(.trailing, 8)
                .padding(.top, 12)
            }
            .frame(width: 110, height: 152)
            .clipped()
        }

    }
}
