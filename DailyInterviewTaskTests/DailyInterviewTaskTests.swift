import XCTest
@testable import DailyInterviewTask

final class DailyInterviewTaskTests: XCTestCase {
    func testQuestionsJSONLoadsBlind75Problems() throws {
        let questions = try JSONDecoder().decode(
            [Question].self,
            from: Data(contentsOf: Self.questionsFileURL)
        )

        XCTAssertEqual(questions.count, 75)
        XCTAssertTrue(questions.allSatisfy { $0.solutions.count >= 2 })
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

    func testProgressScopeFiltersQuestions() {
        let defaults = UserDefaults(suiteName: #function)!
        defaults.removePersistentDomain(forName: #function)
        defaults.set(["q-1"], forKey: "completedQuestionIDs")
        defaults.set(["q-2"], forKey: "bookmarkedQuestionIDs")

        let viewModel = ProgressViewModel(
            repository: MockQuestionRepository(questions: Array(MockData.questions.prefix(3))),
            progressStorage: ProgressStorageService(userDefaults: defaults)
        )

        viewModel.selectedScope = .total
        XCTAssertEqual(viewModel.displayedQuestions.count, 3)

        viewModel.selectedScope = .completed
        XCTAssertEqual(viewModel.displayedQuestions.map(\.id), ["q-1"])

        viewModel.selectedScope = .bookmarked
        XCTAssertEqual(viewModel.displayedQuestions.map(\.id), ["q-2"])
    }
}

private enum MockData {
    static let questions: [Question] = (0..<75).map { index in
        Question(
            id: "q-\(index)",
            title: LocalizedText(
                english: "Question \(index)",
                chinese: "Question \(index)"
            ),
            difficulty: .easy,
            topic: index.isMultiple(of: 2) ? "Arrays" : "Graphs",
            shortSummary: LocalizedText(
                english: "Summary \(index)",
                chinese: "总结 \(index)"
            ),
            companyTags: ["Meta"],
            description: LocalizedText(
                english: "Description",
                chinese: "描述"
            ),
            exampleInput: "Input",
            exampleOutput: "Output",
            exampleExplanation: LocalizedText(
                english: "Explanation",
                chinese: "解释"
            ),
            constraints: ["Constraint"],
            notes: [
                LocalizedText(
                    english: "Note",
                    chinese: "提示"
                )
            ],
            solutions: [
                QuestionSolution(
                    id: "solution-\(index)-optimal",
                    title: LocalizedText(
                        english: "Optimal",
                        chinese: "最优解"
                    ),
                    isOptimal: true,
                    intuition: LocalizedText(
                        english: "Intuition",
                        chinese: "思路"
                    ),
                    steps: [
                        LocalizedText(
                            english: "Step 1",
                            chinese: "步骤 1"
                        )
                    ],
                    explanation: LocalizedText(
                        english: "Explanation",
                        chinese: "解释"
                    ),
                    timeComplexity: "O(1)",
                    spaceComplexity: "O(1)",
                    notes: [
                        LocalizedText(
                            english: "Mistake",
                            chinese: "误区"
                        )
                    ],
                    pythonCode: "print('optimal')"
                ),
                QuestionSolution(
                    id: "solution-\(index)-alternative",
                    title: LocalizedText(
                        english: "Alternative",
                        chinese: "备选解"
                    ),
                    isOptimal: false,
                    intuition: LocalizedText(
                        english: "Alternative intuition",
                        chinese: "备选思路"
                    ),
                    steps: [
                        LocalizedText(
                            english: "Step A",
                            chinese: "步骤 A"
                        )
                    ],
                    explanation: LocalizedText(
                        english: "Alternative explanation",
                        chinese: "备选解释"
                    ),
                    timeComplexity: "O(n)",
                    spaceComplexity: "O(n)",
                    notes: [
                        LocalizedText(
                            english: "Tradeoff",
                            chinese: "取舍"
                        )
                    ],
                    pythonCode: "print('alternative')"
                )
            ]
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
