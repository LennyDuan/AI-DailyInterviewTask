import SwiftUI

struct SectionCardView<Content: View>: View {
    let eyebrow: String
    let title: String
    let content: Content

    init(
        eyebrow: String,
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(eyebrow.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.title3.weight(.semibold))
            }

            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.background)
                .shadow(color: Color.black.opacity(0.05), radius: 24, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}
