import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String
    let tint: Color
    var isSelected: Bool = false
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(isSelected ? .white : tint)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? tint.opacity(0.2) : tint.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var background: some ShapeStyle {
        if isSelected {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [tint, tint.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(tint.opacity(0.10))
    }
}
