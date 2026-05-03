import SwiftData
import Foundation

@Observable
final class BrowseViewModel {
    var searchText: String = ""
    var selectedPartOfSpeech: String = "All"
    var showMasteredOnly: Bool = false

    var filterOptions: [String] {
        ["All"] + Word.partsOfSpeech
    }

    func filteredWords(_ words: [Word]) -> [Word] {
        words.filter { word in
            let matchesSearch = searchText.isEmpty ||
                word.latin.localizedCaseInsensitiveContains(searchText) ||
                word.english.localizedCaseInsensitiveContains(searchText)
            let matchesPOS = selectedPartOfSpeech == "All" || word.partOfSpeech == selectedPartOfSpeech
            let matchesMastered = !showMasteredOnly || word.isMastered
            return matchesSearch && matchesPOS && matchesMastered
        }
        .sorted { $0.latin < $1.latin }
    }

    func deleteWords(_ words: [Word], offsets: IndexSet, context: ModelContext) {
        let filtered = filteredWords(words)
        offsets.forEach { index in
            context.delete(filtered[index])
        }
        try? context.save()
    }

    func toggleMastered(_ word: Word, context: ModelContext) {
        word.isMastered.toggle()
        try? context.save()
    }
}
