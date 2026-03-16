import SwiftUI

struct SolutionView: View {
    @EnvironmentObject private var appSettings: AppSettings

    let question: Question

    @State private var selectedSolutionID: String

    init(question: Question) {
        self.question = question
        _selectedSolutionID = State(initialValue: question.optimalSolution.id)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                solutionSelector

                SectionCardView(eyebrow: selectedSolution.isOptimal ? "Optimal Solution" : "Alternative Solution", title: selectedSolution.title.value(for: appSettings.selectedLanguage)) {
                    Text(selectedSolution.explanation.value(for: appSettings.selectedLanguage))
                        .foregroundStyle(.secondary)
                }

                SectionCardView(eyebrow: "Intuition", title: localized("Core idea")) {
                    Text(selectedSolution.intuition.value(for: appSettings.selectedLanguage))
                        .foregroundStyle(.secondary)
                }

                SectionCardView(eyebrow: "Approach", title: localized("Steps")) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(selectedSolution.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                                    .background(Color.blue, in: Circle())
                                Text(step.value(for: appSettings.selectedLanguage))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                SectionCardView(eyebrow: "Complexity", title: localized("Performance")) {
                    HStack(spacing: 12) {
                        complexityPill(title: localized("Time"), value: selectedSolution.timeComplexity, tint: .purple)
                        complexityPill(title: localized("Space"), value: selectedSolution.spaceComplexity, tint: .orange)
                    }
                }

                SectionCardView(eyebrow: "Code", title: localized("Python implementation")) {
                    CodeBlockView(code: selectedSolution.pythonCode)
                }

                if !selectedSolution.notes.isEmpty {
                    SectionCardView(eyebrow: "Notes", title: localized("Common pitfalls")) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(selectedSolution.notes, id: \.self) { note in
                                Text("• \(note.value(for: appSettings.selectedLanguage))")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
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
        .navigationTitle(localized("Solutions"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var selectedSolution: QuestionSolution {
        question.solutions.first(where: { $0.id == selectedSolutionID }) ?? question.optimalSolution
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(question.title.value(for: appSettings.selectedLanguage))
                        .font(.largeTitle.weight(.bold))
                    Text(localized("Optimal solution is selected by default. Explore alternatives below."))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                LanguageToggleView()
            }

            HStack(spacing: 8) {
                DifficultyBadge(difficulty: question.difficulty)
                Text(question.topic)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.indigo.opacity(0.12), Color.orange.opacity(0.14)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    private var solutionSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(question.solutions) { solution in
                    Button {
                        selectedSolutionID = solution.id
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(solution.title.value(for: appSettings.selectedLanguage))
                                .font(.subheadline.weight(.semibold))
                            Text(solution.isOptimal ? localized("Optimal") : localized("Alternative"))
                                .font(.caption)
                                .foregroundStyle(selectedSolutionID == solution.id ? .white.opacity(0.8) : .secondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(selectedSolutionID == solution.id ? Color.blue : Color.white)
                        )
                        .foregroundStyle(selectedSolutionID == solution.id ? .white : .primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.black.opacity(selectedSolutionID == solution.id ? 0 : 0.08), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func complexityPill(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundStyle(tint)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func localized(_ english: String) -> String {
        switch appSettings.selectedLanguage {
        case .english:
            return english
        case .chinese:
            switch english {
            case "Core idea": return "核心思路"
            case "Steps": return "步骤"
            case "Performance": return "复杂度"
            case "Time": return "时间"
            case "Space": return "空间"
            case "Python implementation": return "Python 实现"
            case "Common pitfalls": return "常见陷阱"
            case "Solutions": return "题解"
            case "Optimal solution is selected by default. Explore alternatives below.": return "默认优先展示最优解，你可以继续查看其他思路。"
            case "Optimal": return "最优解"
            case "Alternative": return "备选解"
            default: return english
            }
        }
    }
}
