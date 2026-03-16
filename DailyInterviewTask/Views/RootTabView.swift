import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var appNavigation: AppNavigation

    let repository: QuestionRepository
    let progressStorage: ProgressStorageServicing

    var body: some View {
        TabView(selection: $appNavigation.selectedTab) {
            HomeView(repository: repository, progressStorage: progressStorage)
                .tag(AppTab.home)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            AllProblemsView(repository: repository, progressStorage: progressStorage)
                .tag(AppTab.allProblems)
                .tabItem {
                    Label("All Problems", systemImage: "square.grid.2x2.fill")
                }

            ProgressView(repository: repository, progressStorage: progressStorage)
                .tag(AppTab.progress)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
        }
        .preferredColorScheme(.light)
    }
}
