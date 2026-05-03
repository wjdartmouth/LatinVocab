import SwiftData
import Foundation

@Observable
final class AddWordViewModel {
    var latin: String = ""
    var english: String = ""
    var partOfSpeech: String = "Noun"
    var notes: String = ""
    var errorMessage: String?

    var isValid: Bool {
        !latin.trimmingCharacters(in: .whitespaces).isEmpty &&
        !english.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save(context: ModelContext) -> Bool {
        guard isValid else {
            errorMessage = "Latin and English fields are required."
            return false
        }
        let word = Word(
            latin: latin.trimmingCharacters(in: .whitespaces),
            english: english.trimmingCharacters(in: .whitespaces),
            partOfSpeech: partOfSpeech,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        context.insert(word)
        do {
            try context.save()
            reset()
            return true
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            return false
        }
    }

    func populate(from word: Word) {
        latin = word.latin
        english = word.english
        partOfSpeech = word.partOfSpeech
        notes = word.notes
    }

    func update(word: Word, context: ModelContext) -> Bool {
        guard isValid else {
            errorMessage = "Latin and English fields are required."
            return false
        }
        word.latin = latin.trimmingCharacters(in: .whitespaces)
        word.english = english.trimmingCharacters(in: .whitespaces)
        word.partOfSpeech = partOfSpeech
        word.notes = notes.trimmingCharacters(in: .whitespaces)
        do {
            try context.save()
            return true
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            return false
        }
    }

    func reset() {
        latin = ""
        english = ""
        partOfSpeech = "Noun"
        notes = ""
        errorMessage = nil
    }
}
