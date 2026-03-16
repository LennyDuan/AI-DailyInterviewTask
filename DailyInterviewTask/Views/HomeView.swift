import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appNavigation: AppNavigation
    @StateObject private var viewModel: HomeViewModel
    private let progressStorage: ProgressStorageServicing

    @State private var navigationPath: [Question] = []
    @State private var showingLoadError = false

    init(repository: QuestionRepository, progressStorage: ProgressStorageServicing) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(
                repository: repository,
                progressStorage: progressStorage
            )
        )
        self.progressStorage = progressStorage
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroSection
                    progressSection
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationDestination(for: Question.self) { question in
                QuestionDetailView(
                    viewModel: QuestionDetailViewModel(
                        question: question,
                        progressStorage: progressStorage
                    )
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .alert("Unable to Load Questions", isPresented: $showingLoadError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.loadError ?? "")
            }
            .onAppear {
                viewModel.refresh()
                showingLoadError = viewModel.loadError != nil
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Algo Daily")
                .font(.largeTitle.weight(.bold))

            Text("Study one strong problem at a time, then jump to a fresh challenge when you are ready.")
                .font(.body)
                .foregroundStyle(.secondary)

            if let recommendation = viewModel.displayedRecommendation {
                SectionCardView(eyebrow: "Daily Recommendation", title: recommendation.title.english) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 10) {
                            DifficultyBadge(difficulty: recommendation.difficulty)
                            Text(recommendation.topic)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        Text(recommendation.shortSummary.english)
                            .font(.body)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            Button("View Problem") {
                                navigationPath.append(recommendation)
                            }
                            .buttonStyle(HomeActionButtonStyle(tint: .blue))

                            Button("Random Next") {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    _ = viewModel.randomNextQuestion()
                                }
                            }
                            .buttonStyle(HomeActionButtonStyle(tint: Color(red: 0.13, green: 0.60, blue: 0.46)))
                        }
                    }
                }
                .id(recommendation.id)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.10), Color.teal.opacity(0.14)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            }
        }
    }

    private var progressSection: some View {
        SectionCardView(eyebrow: "Completion Progress", title: "Track your Algo Daily momentum") {
            VStack(alignment: .leading, spacing: 16) {
                ProgressBarRowView(
                    title: "Overall Progress",
                    subtitle: "\(viewModel.completedCount)/\(viewModel.questions.count)",
                    progress: viewModel.completionPercentage,
                    tint: .blue,
                    action: {
                        appNavigation.showAllProblems()
                    }
                )

                VStack(alignment: .leading, spacing: 12) {
                    Text("By Topic")
                        .font(.headline)

                    ForEach(viewModel.topicProgress) { item in
                        ProgressBarRowView(
                            title: item.topic,
                            subtitle: "\(item.completedCount)/\(item.totalCount)",
                            progress: item.percentage,
                            tint: tint(for: item.topic),
                            action: {
                                appNavigation.showAllProblems(filteredBy: item.topic)
                            }
                        )
                    }
                }
            }
        }
    }

    private func tint(for topic: String) -> Color {
        let palette: [Color] = [.blue, .green, .orange, .pink, .teal, .indigo]
        let index = abs(topic.hashValue) % palette.count
        return palette[index]
    }
}

private struct HomeActionButtonStyle: ButtonStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(tint.opacity(configuration.isPressed ? 0.75 : 1))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
