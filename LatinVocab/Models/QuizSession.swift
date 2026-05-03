import SwiftData
import Foundation

@Model
final class QuizSession {
    var id: UUID
    var date: Date
    var score: Int
    var totalAsked: Int

    init(score: Int, totalAsked: Int) {
        self.id = UUID()
        self.date = Date()
        self.score = score
        self.totalAsked = totalAsked
    }

    var percentage: Double {
        guard totalAsked > 0 else { return 0 }
        return Double(score) / Double(totalAsked) * 100
    }
}
