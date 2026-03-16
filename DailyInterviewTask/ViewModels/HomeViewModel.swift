import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var questions: [Question] = []
    @Published private(set) var completedIDs: Set<String> = []
    @Published private(set) var bookmarkedIDs: Set<String> = []
    @Published private(set) var loadError: String?

    private let repository: QuestionRepository
    private let progressStorage: ProgressStorageServicing
    private let calendar: Calendar
    private let date: Date

    init(
        repository: QuestionRepository,
        progressStorage: ProgressStorageServicing,
        calendar: Calendar = .current,
        date: Date = .now
    ) {
        self.repository = repository
        self.progressStorage = progressStorage
        self.calendar = calendar
        self.date = date
        refresh()
    }

    var recommendedQuestion: Question? {
        guard !questions.isEmpty else { return nil }
        let currentDay = calendar.component(.day, from: date)
        let index = currentDay % questions.count
        return questions[index]
    }

    func refresh() {
        do {
            questions = try repository.loadQuestions()
            completedIDs = progressStorage.completedQuestionIDs()
            bookmarkedIDs = progressStorage.bookmarkedQuestionIDs()
            loadError = nil
        } catch {
            questions = []
            loadError = error.localizedDescription
        }
    }

    func isCompleted(_ question: Question) -> Bool {
        completedIDs.contains(question.id)
    }

    func isBookmarked(_ question: Question) -> Bool {
        bookmarkedIDs.contains(question.id)
    }
}
