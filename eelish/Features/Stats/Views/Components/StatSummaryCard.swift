import SwiftUI

struct StatSummaryCard<Content: View>: View {
    let title: String
    let desc: String
    @ViewBuilder let content: Content

    init(
        title: String,
        desc: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.desc = desc
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.mutedForeground)

            content

            Text(desc)
                .font(.system(size: 11).weight(.medium))
                .foregroundStyle(.appPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(
            color: .black.opacity(0.06),
            radius: 3,
            x: 0,
            y: 1
        )
    }
}
