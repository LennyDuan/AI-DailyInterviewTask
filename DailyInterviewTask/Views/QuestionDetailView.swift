import SwiftUI

struct QuestionDetailView: View {
    @ObservedObject var viewModel: QuestionDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(viewModel.question.title)
                    .font(.largeTitle.weight(.bold))

                HStack(spacing: 10) {
                    DifficultyBadge(difficulty: viewModel.question.difficulty)
                    Text(viewModel.question.topic)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                if !viewModel.question.companyTags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Company Tags")
                            .font(.headline)
                        Text(viewModel.question.companyTags.joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }
                }

                detailSection(title: "Description", content: viewModel.question.description)
                detailSection(title: "Example Input", content: viewModel.question.exampleInput)
                detailSection(title: "Example Output", content: viewModel.question.exampleOutput)
                detailSection(title: "Explanation", content: viewModel.question.exampleExplanation)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Constraints")
                        .font(.headline)
                    ForEach(viewModel.question.constraints, id: \.self) { constraint in
                        Text("• \(constraint)")
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    Button(viewModel.isCompleted ? "Completed" : "Mark Completed") {
                        viewModel.toggleCompleted()
                    }
                    .buttonStyle(PrimaryActionButtonStyle(tint: .green))

                    Button(viewModel.isBookmarked ? "Unbookmark" : "Bookmark") {
                        viewModel.toggleBookmarked()
                    }
                    .buttonStyle(PrimaryActionButtonStyle(tint: .blue))
                }

                NavigationLink {
                    SolutionView(solution: viewModel.question.solution)
                } label: {
                    Text("View Solution")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryActionButtonStyle(tint: .primary))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Problem")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .foregroundStyle(.secondary)
        }
    }
}

private struct PrimaryActionButtonStyle: ButtonStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(tint.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
