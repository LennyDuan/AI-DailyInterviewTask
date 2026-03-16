import Foundation
import Combine

enum ProgressScope: String, CaseIterable, Identifiable {
    case total
    case completed
    case bookmarked

    var id: String { rawValue }

    var title: String {
        switch self {
        case .total:
            return "Total"
        case .completed:
            return "Completed"
        case .bookmarked:
            return "Bookmarked"
        }
    }
}

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published private(set) var questions: [Question] = []
    @Published private(set) var completedIDs: Set<String> = []
    @Published private(set) var bookmarkedIDs: Set<String> = []
    @Published var selectedScope: ProgressScope = .completed

    private let repository: QuestionRepository
    private let progressStorage: ProgressStorageServicing

    init(repository: QuestionRepository, progressStorage: ProgressStorageServicing) {
        self.repository = repository
        self.progressStorage = progressStorage
        refresh()
    }

    var totalProblems: Int {
        questions.count
    }

    var completedCount: Int {
        completedIDs.count
    }

    var bookmarkedCount: Int {
        bookmarkedIDs.count
    }

    var completionPercentage: Int {
        guard totalProblems > 0 else { return 0 }
        return Int((Double(completedCount) / Double(totalProblems) * 100).rounded())
    }

    var displayedQuestions: [Question] {
        switch selectedScope {
        case .total:
            return questions
        case .completed:
            return questions.filter { completedIDs.contains($0.id) }
        case .bookmarked:
            return questions.filter { bookmarkedIDs.contains($0.id) }
        }
    }

    func refresh() {
        questions = (try? repository.loadQuestions()) ?? []
        completedIDs = progressStorage.completedQuestionIDs()
        bookmarkedIDs = progressStorage.bookmarkedQuestionIDs()
    }
}
