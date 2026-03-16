import Foundation
import Combine

enum AppTab: Hashable {
    case home
    case allProblems
    case progress
}

final class AppNavigation: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var selectedTopicFilter: String = "All"

    func showAllProblems(filteredBy topic: String = "All") {
        selectedTopicFilter = topic
        selectedTab = .allProblems
    }
}
