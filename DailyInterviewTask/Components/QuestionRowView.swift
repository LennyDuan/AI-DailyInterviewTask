import SwiftUI

struct QuestionRowView: View {
    @EnvironmentObject private var appSettings: AppSettings

    let question: Question
    let isCompleted: Bool
    let isBookmarked: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text(question.title.value(for: appSettings.selectedLanguage))
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Text(question.shortSummary.value(for: appSettings.selectedLanguage))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    DifficultyBadge(difficulty: question.difficulty)
                    Text(question.topic)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 12) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isCompleted ? .green : .secondary)

                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.title3)
                    .foregroundStyle(isBookmarked ? .blue : .secondary)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.background)
                .shadow(color: Color.black.opacity(0.04), radius: 18, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }
}
