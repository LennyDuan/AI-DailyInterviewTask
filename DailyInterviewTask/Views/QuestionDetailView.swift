import SwiftUI

struct QuestionDetailView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject var viewModel: QuestionDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                SectionCardView(eyebrow: "Problem", title: localized("Description")) {
                    Text(viewModel.question.description.value(for: appSettings.selectedLanguage))
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                SectionCardView(eyebrow: "Example", title: localized("Walkthrough")) {
                    VStack(alignment: .leading, spacing: 14) {
                        labeledMonospace(title: localized("Input"), value: viewModel.question.exampleInput)
                        labeledMonospace(title: localized("Output"), value: viewModel.question.exampleOutput)
                        detailText(title: localized("Explanation"), content: viewModel.question.exampleExplanation.value(for: appSettings.selectedLanguage))
                    }
                }

                SectionCardView(eyebrow: "Constraints", title: localized("What to watch")) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.question.constraints, id: \.self) { constraint in
                            Label(constraint, systemImage: "circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }

                if !viewModel.question.notes.isEmpty {
                    SectionCardView(eyebrow: "Notes", title: localized("Interview notes")) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.question.notes, id: \.self) { note in
                                Text("• \(note.value(for: appSettings.selectedLanguage))")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                NavigationLink {
                    SolutionView(question: viewModel.question)
                } label: {
                    Text(localized("View Solutions"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryActionButtonStyle(tint: .black))
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
        .navigationTitle(localized("Problem"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.question.title.value(for: appSettings.selectedLanguage))
                        .font(.largeTitle.weight(.bold))
                        .multilineTextAlignment(.leading)

                    Text(viewModel.question.shortSummary.value(for: appSettings.selectedLanguage))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                LanguageToggleView()
            }

            HStack(spacing: 10) {
                DifficultyBadge(difficulty: viewModel.question.difficulty)
                Text(viewModel.question.topic)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            if !viewModel.question.companyTags.isEmpty {
                Text(viewModel.question.companyTags.joined(separator: " • "))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                Button(viewModel.isCompleted ? localized("Completed") : localized("Complete")) {
                    viewModel.toggleCompleted()
                }
                .buttonStyle(PrimaryActionButtonStyle(tint: .green))

                Button(viewModel.isBookmarked ? localized("Bookmarked") : localized("Bookmark")) {
                    viewModel.toggleBookmarked()
                }
                .buttonStyle(PrimaryActionButtonStyle(tint: .blue))
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.10), Color.cyan.opacity(0.16)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    private func detailText(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(content)
                .foregroundStyle(.secondary)
        }
    }

    private func labeledMonospace(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.system(.footnote, design: .monospaced))
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func localized(_ english: String) -> String {
        switch appSettings.selectedLanguage {
        case .english:
            return english
        case .chinese:
            switch english {
            case "Description": return "题目描述"
            case "Walkthrough": return "示例解析"
            case "Input": return "输入"
            case "Output": return "输出"
            case "Explanation": return "解释"
            case "What to watch": return "注意点"
            case "Interview notes": return "面试提示"
            case "View Solutions": return "查看题解"
            case "Problem": return "题目"
            case "Completed": return "已完成"
            case "Complete": return "完成"
            case "Bookmarked": return "已收藏"
            case "Bookmark": return "收藏"
            default: return english
            }
        }
    }
}

private struct PrimaryActionButtonStyle: ButtonStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(tint.opacity(configuration.isPressed ? 0.78 : 1))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
