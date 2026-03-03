//
//  NoteModel.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 11/02/26.
//

import SwiftData
import Foundation
import FoundationModels

@Model
class Note{
    @Attribute(.unique) var id: UUID
    
    var session: Session?
    var book: Book
    var title: String?
    var text: String
    var date: Date
    var summary : String = ""
    
    init(session: Session? = nil, book: Book, text: String, title: String? = nil, date: Date) {
        self.id = UUID()
        self.session = session
        self.book = book
        self.text = text
        self.date = date
    }
    
    nonisolated(nonsending)
    func suggestedTitle(currentText: String) async throws -> String? {
        let fallbackTitle = ""
        let trimmedText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard trimmedText.count > 10 else {
            return fallbackTitle
        }
        
        let model = SystemLanguageModel.default
        
        guard model.isAvailable else {
            return fallbackTitle
        }

        let modelSession = LanguageModelSession(model: model)
        
        let prompt = """
        Summarize this reading note in a 3-word title. 
        CRITICAL RULE: If the text is too short, unclear, gibberish, or lacks meaning, reply with EXACTLY "INSUFFICIENT_CONTEXT" and nothing else.
        
        Note: \(currentText)
        """
        
        do {
            let answer = try await modelSession.respond(to: prompt)
            
            let cleanedAnswer = answer.content.trimmingCharacters(in: .punctuationCharacters)
                                              .trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            if cleanedAnswer == "INSUFFICIENT_CONTEXT" {
                return fallbackTitle
            }
            
            return cleanedAnswer
            
        } catch {
            return fallbackTitle
        }
    }
    
    @MainActor
    func summarizeNote() async throws {
        guard self.text.trimmingCharacters(in: .whitespacesAndNewlines).count > 20 else {
            return
        }
        
        let model = SystemLanguageModel.default
        
        guard model.isAvailable else {
            return
        }
        
        let modelSession = LanguageModelSession(model: model)
        
        let prompt = """
        Extract the core information from the following reading note as a brief, punchy summary.

        RULES:
        - Focus only on the 'What' and 'Why'.
        - NO context phrases: Remove "I discovered", "The author says", "This reveals", or "I'm rethinking".
        - Start directly with the key fact or concept.
        - Maximum 2-3 sentences.
        - Use a neutral, objective tone.
        - CRITICAL RULE: If the text is gibberish, unclear, or lacks enough context to form a summary, reply with EXACTLY "INSUFFICIENT_CONTEXT" and nothing else.

        Reading note: \(self.text)
        """
        
        do {
            let answer = try await modelSession.respond(to: prompt)
            let cleanedAnswer = answer.content.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
                if cleanedAnswer == "INSUFFICIENT_CONTEXT" {
                    return
                }
                
            self.summary = cleanedAnswer
            try? self.modelContext?.save()
            
        } catch {
            print("Summarization failed:", error)
            throw error
        }
    }
}

