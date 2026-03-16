import Foundation
import Combine

@MainActor
final class AllProblemsViewModel: ObservableObject {
    @Published private(set) var questions: [Question] = []
    @Published private(set) var completedIDs: Set<String> = []
    @Published private(set) var bookmarkedIDs: Set<String> = []
    @Published private(set) var loadError: String?

    private let repository: QuestionRepository
    private let progressStorage: ProgressStorageServicing

    init(repository: QuestionRepository, progressStorage: ProgressStorageServicing) {
        self.repository = repository
        self.progressStorage = progressStorage
        refresh()
    }

    var topics: [String] {
        Array(Set(questions.map(\.topic))).sorted()
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
