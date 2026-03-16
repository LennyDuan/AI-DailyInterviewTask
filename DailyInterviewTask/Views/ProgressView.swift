import SwiftUI

struct ProgressView: View {
    @StateObject private var viewModel: ProgressViewModel
    private let progressStorage: ProgressStorageServicing

    init(repository: QuestionRepository, progressStorage: ProgressStorageServicing) {
        _viewModel = StateObject(
            wrappedValue: ProgressViewModel(
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
                    Text("Learning Progress")
                        .font(.largeTitle.weight(.bold))

                    Text("Tap a metric to switch the detailed list instantly.")
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        StatCardView(
                            title: "Total",
                            value: "\(viewModel.totalProblems)",
                            tint: .blue,
                            isSelected: viewModel.selectedScope == .total
                        ) {
                            viewModel.selectedScope = .total
                        }

                        StatCardView(
                            title: "Completed",
                            value: "\(viewModel.completedCount)",
                            tint: .green,
                            isSelected: viewModel.selectedScope == .completed
                        ) {
                            viewModel.selectedScope = .completed
                        }
                    }

                    HStack(spacing: 12) {
                        StatCardView(
                            title: "Bookmarked",
                            value: "\(viewModel.bookmarkedCount)",
                            tint: .orange,
                            isSelected: viewModel.selectedScope == .bookmarked
                        ) {
                            viewModel.selectedScope = .bookmarked
                        }

                        StatCardView(
                            title: "Completion",
                            value: "\(viewModel.completionPercentage)%",
                            tint: .purple
                        )
                    }

                    SectionCardView(
                        eyebrow: "Detailed List",
                        title: "\(viewModel.selectedScope.title) Problems"
                    ) {
                        if viewModel.displayedQuestions.isEmpty {
                            Text("No problems match this view yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.displayedQuestions) { question in
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
                                            isCompleted: viewModel.completedIDs.contains(question.id),
                                            isBookmarked: viewModel.bookmarkedIDs.contains(question.id)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}
