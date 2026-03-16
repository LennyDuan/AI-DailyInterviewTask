import Foundation
import Combine

final class AppSettings: ObservableObject {
    private enum Keys {
        static let selectedLanguage = "selectedLanguage"
    }

    @Published var selectedLanguage: AppLanguage {
        didSet {
            userDefaults.set(selectedLanguage.rawValue, forKey: Keys.selectedLanguage)
        }
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.selectedLanguage = AppLanguage(
            rawValue: userDefaults.string(forKey: Keys.selectedLanguage) ?? ""
        ) ?? .english
    }
}
