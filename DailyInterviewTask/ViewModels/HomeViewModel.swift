import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var questions: [Question] = []
    @Published private(set) var completedIDs: Set<String> = []
    @Published private(set) var bookmarkedIDs: Set<String> = []
    @Published private(set) var loadError: String?
    @Published private(set) var displayedRecommendation: Question?

    private let repository: QuestionRepository
    private let progressStorage: ProgressStorageServicing
    private let calendar: Calendar
    private let date: Date
    private var recentRandomQuestionIDs: [String] = []

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

    var completedCount: Int {
        completedIDs.count
    }

    var completionPercentage: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(completedCount) / Double(questions.count)
    }

    var topicProgress: [TopicProgress] {
        let grouped = Dictionary(grouping: questions, by: \.topic)
        return grouped
            .map { topic, items in
                TopicProgress(
                    topic: topic,
                    completedCount: items.filter { completedIDs.contains($0.id) }.count,
                    totalCount: items.count
                )
            }
            .sorted { lhs, rhs in
                if lhs.percentage == rhs.percentage {
                    return lhs.topic < rhs.topic
                }
                return lhs.percentage > rhs.percentage
            }
    }

    func refresh() {
        do {
            questions = try repository.loadQuestions()
            completedIDs = progressStorage.completedQuestionIDs()
            bookmarkedIDs = progressStorage.bookmarkedQuestionIDs()
            if let displayedRecommendation, questions.contains(displayedRecommendation) {
                self.displayedRecommendation = displayedRecommendation
            } else {
                displayedRecommendation = recommendedQuestion
            }
            loadError = nil
        } catch {
            questions = []
            displayedRecommendation = nil
            loadError = error.localizedDescription
        }
    }

    func isCompleted(_ question: Question) -> Bool {
        completedIDs.contains(question.id)
    }

    func isBookmarked(_ question: Question) -> Bool {
        bookmarkedIDs.contains(question.id)
    }

    func randomNextQuestion() -> Question? {
        guard !questions.isEmpty else { return nil }

        let recentLimit = min(6, max(1, questions.count / 10))
        let excludedIDs = Set(recentRandomQuestionIDs.suffix(recentLimit))
        let candidatePool = questions.filter {
            !excludedIDs.contains($0.id) && $0.id != displayedRecommendation?.id
        }
        let pool = candidatePool.isEmpty ? questions : candidatePool

        guard let selectedQuestion = pool.randomElement() else { return nil }
        recentRandomQuestionIDs.append(selectedQuestion.id)
        if recentRandomQuestionIDs.count > recentLimit * 2 {
            recentRandomQuestionIDs.removeFirst(recentRandomQuestionIDs.count - (recentLimit * 2))
        }
        displayedRecommendation = selectedQuestion
        return selectedQuestion
    }
}
