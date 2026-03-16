import SwiftUI

struct LanguageToggleView: View {
    @EnvironmentObject private var appSettings: AppSettings

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppLanguage.allCases) { language in
                Button {
                    appSettings.selectedLanguage = language
                } label: {
                    Text(language.title)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(appSettings.selectedLanguage == language ? .white : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(appSettings.selectedLanguage == language ? Color.blue : Color.white.opacity(0.85))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(.ultraThinMaterial, in: Capsule(style: .continuous))
    }
}
