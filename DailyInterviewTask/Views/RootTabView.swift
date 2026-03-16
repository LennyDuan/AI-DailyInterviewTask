import SwiftUI

struct RootTabView: View {
    let repository: QuestionRepository
    let progressStorage: ProgressStorageServicing

    var body: some View {
        TabView {
            HomeView(repository: repository, progressStorage: progressStorage)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ProgressView(repository: repository, progressStorage: progressStorage)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
        }
        .preferredColorScheme(.light)
    }
}
