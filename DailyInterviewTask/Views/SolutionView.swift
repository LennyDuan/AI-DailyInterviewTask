import SwiftUI

struct SolutionView: View {
    let solution: QuestionSolution

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                detailSection(title: "Approach", content: solution.approachName)
                detailSection(title: "Intuition", content: solution.intuition)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Steps")
                        .font(.headline)
                    ForEach(Array(solution.steps.enumerated()), id: \.offset) { index, step in
                        Text("\(index + 1). \(step)")
                            .foregroundStyle(.secondary)
                    }
                }

                detailSection(title: "Why Optimal", content: solution.whyOptimal)
                detailSection(title: "Time Complexity", content: solution.timeComplexity)
                detailSection(title: "Space Complexity", content: solution.spaceComplexity)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Common Mistakes")
                        .font(.headline)
                    ForEach(solution.commonMistakes, id: \.self) { item in
                        Text("• \(item)")
                            .foregroundStyle(.secondary)
                    }
                }

                detailSection(title: "Interview Tip", content: solution.interviewTip)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Python Example")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(solution.pythonCode)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Solution")
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
