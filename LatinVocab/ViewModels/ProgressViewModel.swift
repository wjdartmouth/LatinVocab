import SwiftData
import Foundation

@Observable
final class ProgressViewModel {

    func totalWords(_ words: [Word]) -> Int { words.count }

    func masteredCount(_ words: [Word]) -> Int {
        words.filter { $0.isMastered }.count
    }

    func masteredPercentage(_ words: [Word]) -> Double {
        guard !words.isEmpty else { return 0 }
        return Double(masteredCount(words)) / Double(words.count) * 100
    }

    func averageScore(_ sessions: [QuizSession]) -> Double {
        guard !sessions.isEmpty else { return 0 }
        let total = sessions.reduce(0.0) { $0 + $1.percentage }
        return total / Double(sessions.count)
    }

    func recentSessions(_ sessions: [QuizSession], limit: Int = 7) -> [QuizSession] {
        sessions.sorted { $0.date > $1.date }.prefix(limit).map { $0 }
    }

    func hardestWords(_ words: [Word], limit: Int = 5) -> [Word] {
        words
            .filter { $0.timesQuizzed >= 2 }
            .sorted { $0.accuracy < $1.accuracy }
            .prefix(limit)
            .map { $0 }
    }

    func streakDays(_ sessions: [QuizSession]) -> Int {
        let calendar = Calendar.current
        let sortedDates = sessions
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)
        guard let latest = sortedDates.first else { return 0 }
        guard calendar.isDateInToday(latest) || calendar.isDateInYesterday(latest) else { return 0 }

        var streak = 1
        var current = latest
        for date in sortedDates.dropFirst() {
            let expected = calendar.date(byAdding: .day, value: -1, to: current)!
            if calendar.isDate(date, inSameDayAs: expected) {
                streak += 1
                current = date
            } else if !calendar.isDate(date, inSameDayAs: current) {
                break
            }
        }
        return streak
    }
}
