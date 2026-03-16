import XCTest
@testable import DailyInterviewTask

final class DailyInterviewTaskTests: XCTestCase {
    func testQuestionsJSONLoadsTwentyProblems() throws {
        let questions = try JSONDecoder().decode(
            [Question].self,
            from: Data(contentsOf: Self.questionsFileURL)
        )

        XCTAssertEqual(questions.count, 20)
    }

    func testDailyRecommendationLogicUsesCurrentDayModuloQuestionCount() {
        let viewModel = HomeViewModel(
            repository: MockQuestionRepository(questions: MockData.questions),
            progressStorage: ProgressStorageService(userDefaults: UserDefaults(suiteName: #function) ?? .standard),
            calendar: Calendar(identifier: .gregorian),
            date: Self.makeDate(day: 5)
        )

        XCTAssertEqual(viewModel.recommendedQuestion?.id, MockData.questions[5].id)
    }

    func testBookmarkToggleUpdatesStoredIDs() {
        let defaults = UserDefaults(suiteName: #function)!
        defaults.removePersistentDomain(forName: #function)
        let service = ProgressStorageService(userDefaults: defaults)

        service.toggleBookmarked("two-sum")
        XCTAssertTrue(service.isBookmarked("two-sum"))

        service.toggleBookmarked("two-sum")
        XCTAssertFalse(service.isBookmarked("two-sum"))
    }

    func testCompletionToggleUpdatesStoredIDs() {
        let defaults = UserDefaults(suiteName: #function)!
        defaults.removePersistentDomain(forName: #function)
        let service = ProgressStorageService(userDefaults: defaults)

        service.toggleCompleted("two-sum")
        XCTAssertTrue(service.isCompleted("two-sum"))

        service.toggleCompleted("two-sum")
        XCTAssertFalse(service.isCompleted("two-sum"))
    }
}

private enum MockData {
    static let questions: [Question] = (0..<20).map { index in
        Question(
            id: "q-\(index)",
            title: "Question \(index)",
            difficulty: .easy,
            topic: "Arrays",
            shortSummary: "Summary \(index)",
            companyTags: ["Meta"],
            description: "Description",
            exampleInput: "Input",
            exampleOutput: "Output",
            exampleExplanation: "Explanation",
            constraints: ["Constraint"],
            solution: QuestionSolution(
                approachName: "Approach",
                intuition: "Intuition",
                steps: ["Step"],
                whyOptimal: "Optimal",
                timeComplexity: "O(1)",
                spaceComplexity: "O(1)",
                commonMistakes: ["Mistake"],
                interviewTip: "Tip",
                pythonCode: "print('hello')"
            )
        )
    }
}

private struct MockQuestionRepository: QuestionRepository {
    let questions: [Question]

    func loadQuestions() throws -> [Question] {
        questions
    }
}

private extension DailyInterviewTaskTests {
    static var questionsFileURL: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("DailyInterviewTask")
            .appendingPathComponent("Resources")
            .appendingPathComponent("questions.json")
    }

    static func makeDate(day: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: DateComponents(year: 2026, month: 1, day: day)) ?? .now
    }
}
