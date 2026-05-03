import SwiftData
import Foundation

@Model
final class Word {
    var id: UUID
    var latin: String
    var english: String
    var partOfSpeech: String
    var notes: String
    var isMastered: Bool
    var dateAdded: Date
    var timesQuizzed: Int
    var timesCorrect: Int

    init(latin: String, english: String, partOfSpeech: String, notes: String = "") {
        self.id = UUID()
        self.latin = latin
        self.english = english
        self.partOfSpeech = partOfSpeech
        self.notes = notes
        self.isMastered = false
        self.dateAdded = Date()
        self.timesQuizzed = 0
        self.timesCorrect = 0
    }

    var accuracy: Double {
        guard timesQuizzed > 0 else { return 0 }
        return Double(timesCorrect) / Double(timesQuizzed)
    }
}

extension Word {
    static var partsOfSpeech: [String] {
        ["Noun", "Verb", "Adjective", "Adverb", "Preposition", "Conjunction", "Pronoun", "Other"]
    }
}
