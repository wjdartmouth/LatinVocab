import XCTest

final class LatinVocabTests: XCTestCase {
    func testWordAccuracy() {
        let word = Word(latin: "amor", english: "love", partOfSpeech: "Noun")
        XCTAssertEqual(word.accuracy, 0.0)
        word.timesQuizzed = 4
        word.timesCorrect = 3
        XCTAssertEqual(word.accuracy, 0.75, accuracy: 0.001)
    }

    func testQuizSessionPercentage() {
        let session = QuizSession(score: 8, totalAsked: 10)
        XCTAssertEqual(session.percentage, 80.0, accuracy: 0.001)
    }
}
