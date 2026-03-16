import SwiftUI

struct ProgressView: View {
    @StateObject private var viewModel: ProgressViewModel

    init(repository: QuestionRepository, progressStorage: ProgressStorageServicing) {
        _viewModel = StateObject(
            wrappedValue: ProgressViewModel(
                repository: repository,
                progressStorage: progressStorage
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Learning Progress")
                        .font(.largeTitle.weight(.bold))

                    HStack(spacing: 12) {
                        StatCardView(
                            title: "Total",
                            value: "\(viewModel.totalProblems)",
                            tint: .blue
                        )
                        StatCardView(
                            title: "Completed",
                            value: "\(viewModel.completedCount)",
                            tint: .green
                        )
                    }

                    HStack(spacing: 12) {
                        StatCardView(
                            title: "Bookmarked",
                            value: "\(viewModel.bookmarkedCount)",
                            tint: .orange
                        )
                        StatCardView(
                            title: "Completion",
                            value: "\(viewModel.completionPercentage)%",
                            tint: .purple
                        )
                    }

                    Text("Completed Problems")
                        .font(.title3.weight(.semibold))

                    if viewModel.completedQuestions.isEmpty {
                        Text("Complete a few questions to build momentum.")
                            .foregroundStyle(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.completedQuestions) { question in
                                QuestionRowView(
                                    question: question,
                                    isCompleted: true,
                                    isBookmarked: viewModel.bookmarkedIDs.contains(question.id)
                                )
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
