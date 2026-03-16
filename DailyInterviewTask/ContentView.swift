import SwiftUI

struct ContentView: View {
    @StateObject private var appSettings = AppSettings()
    @StateObject private var appNavigation = AppNavigation()

    private let repository = LocalQuestionRepository()
    private let progressStorage = ProgressStorageService()

    var body: some View {
        RootTabView(repository: repository, progressStorage: progressStorage)
            .environmentObject(appSettings)
            .environmentObject(appNavigation)
    }
}

#Preview {
    ContentView()
}
