import Foundation
import Combine

@MainActor
final class QuestionDetailViewModel: ObservableObject {
    @Published private(set) var completedIDs: Set<String>
    @Published private(set) var bookmarkedIDs: Set<String>

    let question: Question

    private let progressStorage: ProgressStorageServicing

    init(question: Question, progressStorage: ProgressStorageServicing) {
        self.question = question
        self.progressStorage = progressStorage
        self.completedIDs = progressStorage.completedQuestionIDs()
        self.bookmarkedIDs = progressStorage.bookmarkedQuestionIDs()
    }

    var isCompleted: Bool {
        completedIDs.contains(question.id)
    }

    var isBookmarked: Bool {
        bookmarkedIDs.contains(question.id)
    }

    func toggleCompleted() {
        progressStorage.toggleCompleted(question.id)
        completedIDs = progressStorage.completedQuestionIDs()
    }

    func toggleBookmarked() {
        progressStorage.toggleBookmarked(question.id)
        bookmarkedIDs = progressStorage.bookmarkedQuestionIDs()
    }
}
