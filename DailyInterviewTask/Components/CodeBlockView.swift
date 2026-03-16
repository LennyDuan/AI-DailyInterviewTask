import SwiftUI

struct CodeBlockView: View {
    let code: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.footnote, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color(red: 0.08, green: 0.11, blue: 0.16), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .foregroundStyle(.white)
        }
    }
}
