import Foundation

protocol ProgressStorageServicing {
    func completedQuestionIDs() -> Set<String>
    func bookmarkedQuestionIDs() -> Set<String>
    func isCompleted(_ questionID: String) -> Bool
    func isBookmarked(_ questionID: String) -> Bool
    func toggleCompleted(_ questionID: String)
    func toggleBookmarked(_ questionID: String)
}

final class ProgressStorageService: ProgressStorageServicing {
    private enum Keys {
        static let completed = "completedQuestionIDs"
        static let bookmarked = "bookmarkedQuestionIDs"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func completedQuestionIDs() -> Set<String> {
        storedIDs(forKey: Keys.completed)
    }

    func bookmarkedQuestionIDs() -> Set<String> {
        storedIDs(forKey: Keys.bookmarked)
    }

    func isCompleted(_ questionID: String) -> Bool {
        completedQuestionIDs().contains(questionID)
    }

    func isBookmarked(_ questionID: String) -> Bool {
        bookmarkedQuestionIDs().contains(questionID)
    }

    func toggleCompleted(_ questionID: String) {
        toggle(questionID, key: Keys.completed)
    }

    func toggleBookmarked(_ questionID: String) {
        toggle(questionID, key: Keys.bookmarked)
    }

    private func storedIDs(forKey key: String) -> Set<String> {
        let values = userDefaults.array(forKey: key) as? [String] ?? []
        return Set(values)
    }

    private func toggle(_ questionID: String, key: String) {
        var ids = storedIDs(forKey: key)
        if ids.contains(questionID) {
            ids.remove(questionID)
        } else {
            ids.insert(questionID)
        }
        userDefaults.set(Array(ids).sorted(), forKey: key)
    }
}
