import SwiftData
import Foundation

@MainActor
final class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init() {
        let schema = Schema([Word.self, QuizSession.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: config)
            seedIfNeeded()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    private func seedIfNeeded() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<Word>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let seedWords: [(String, String, String)] = [
            ("amor", "love", "Noun"),
            ("aqua", "water", "Noun"),
            ("bellum", "war", "Noun"),
            ("caelum", "sky, heaven", "Noun"),
            ("deus", "god", "Noun"),
            ("femina", "woman", "Noun"),
            ("filius", "son", "Noun"),
            ("homo", "man, human being", "Noun"),
            ("lux", "light", "Noun"),
            ("mare", "sea", "Noun"),
            ("pax", "peace", "Noun"),
            ("terra", "earth, land", "Noun"),
            ("tempus", "time", "Noun"),
            ("vita", "life", "Noun"),
            ("vox", "voice", "Noun"),
            ("amare", "to love", "Verb"),
            ("esse", "to be", "Verb"),
            ("facere", "to make, to do", "Verb"),
            ("venire", "to come", "Verb"),
            ("videre", "to see", "Verb"),
            ("magnus", "great, large", "Adjective"),
            ("bonus", "good", "Adjective"),
            ("novus", "new", "Adjective"),
            ("semper", "always", "Adverb"),
            ("non", "not", "Adverb"),
        ]

        for (latin, english, pos) in seedWords {
            let word = Word(latin: latin, english: english, partOfSpeech: pos)
            context.insert(word)
        }

        try? context.save()
    }
}
