import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let progressStorage: ProgressStorageServicing
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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Algo Daily")
                        .font(.largeTitle.weight(.bold))

                    if let recommendation = viewModel.recommendedQuestion {
                        recommendationCard(for: recommendation)
                    }

                    Text("All Problems")
                        .font(.title3.weight(.semibold))

                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.questions) { question in
                            NavigationLink {
                                QuestionDetailView(
                                    viewModel: QuestionDetailViewModel(
                                        question: question,
                                        progressStorage: progressStorage
                                    )
                                )
                            } label: {
                                QuestionRowView(
                                    question: question,
                                    isCompleted: viewModel.isCompleted(question),
                                    isBookmarked: viewModel.isBookmarked(question)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
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

    @ViewBuilder
    private func recommendationCard(for question: Question) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Recommendation")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(question.title)
                .font(.title3.weight(.semibold))

            HStack(spacing: 8) {
                DifficultyBadge(difficulty: question.difficulty)
                Text(question.topic)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text(question.shortSummary)
                .font(.body)
                .foregroundStyle(.secondary)

            NavigationLink {
                QuestionDetailView(
                    viewModel: QuestionDetailViewModel(
                        question: question,
                        progressStorage: progressStorage
                    )
                )
            } label: {
                Text("View Problem")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.12), Color.teal.opacity(0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
