import SwiftData
import Foundation

enum QuizDirection {
    case latinToEnglish, englishToLatin
}

@Observable
final class QuizViewModel {
    var currentIndex: Int = 0
    var isShowingAnswer: Bool = false
    var sessionScore: Int = 0
    var sessionTotal: Int = 0
    var isSessionComplete: Bool = false
    var quizDirection: QuizDirection = .latinToEnglish
    var shuffledWords: [Word] = []
    var isFlipped: Bool = false

    var currentWord: Word? {
        guard !shuffledWords.isEmpty, currentIndex < shuffledWords.count else { return nil }
        return shuffledWords[currentIndex]
    }

    var promptText: String {
        guard let word = currentWord else { return "" }
        return quizDirection == .latinToEnglish ? word.latin : word.english
    }

    var answerText: String {
        guard let word = currentWord else { return "" }
        return quizDirection == .latinToEnglish ? word.english : word.latin
    }

    var progress: Double {
        guard !shuffledWords.isEmpty else { return 0 }
        return Double(currentIndex) / Double(shuffledWords.count)
    }

    func startSession(with words: [Word], direction: QuizDirection = .latinToEnglish) {
        quizDirection = direction
        shuffledWords = words.shuffled()
        currentIndex = 0
        sessionScore = 0
        sessionTotal = 0
        isSessionComplete = false
        isShowingAnswer = false
        isFlipped = false
    }

    func flipCard() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isFlipped.toggle()
            isShowingAnswer = true
        }
    }

    func markCorrect(context: ModelContext) {
        guard let word = currentWord else { return }
        word.timesQuizzed += 1
        word.timesCorrect += 1
        if word.accuracy >= 0.8 && word.timesQuizzed >= 3 {
            word.isMastered = true
        }
        try? context.save()
        sessionScore += 1
        sessionTotal += 1
        advance()
    }

    func markIncorrect(context: ModelContext) {
        guard let word = currentWord else { return }
        word.timesQuizzed += 1
        word.isMastered = false
        try? context.save()
        sessionTotal += 1
        advance()
    }

    private func advance() {
        if currentIndex + 1 >= shuffledWords.count {
            isSessionComplete = true
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex += 1
                isShowingAnswer = false
                isFlipped = false
            }
        }
    }

    func saveSession(context: ModelContext) {
        let session = QuizSession(score: sessionScore, totalAsked: sessionTotal)
        context.insert(session)
        try? context.save()
    }
}
