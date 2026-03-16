import SwiftUI

struct ProgressBarRowView: View {
    let title: String
    let subtitle: String
    let progress: Double
    let tint: Color
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule(style: .continuous)
                            .fill(tint.opacity(0.12))
                        Capsule(style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [tint, tint.opacity(0.65)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(12, geometry.size.width * progress))
                    }
                }
                .frame(height: 12)

                HStack {
                    Text("\(Int((progress * 100).rounded()))% completed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if action != nil {
                        Image(systemName: "arrow.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(tint)
                    }
                }
            }
            .padding(16)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
