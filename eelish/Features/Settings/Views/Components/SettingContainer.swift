import SwiftUI

struct SettingRowData: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let leftContent: AnyView
    
    init<Content: View>(
        icon: String,
        title: String,
        @ViewBuilder leftContent: () -> Content
    ) {
        self.icon = icon
        self.title = title
        self.leftContent = AnyView(leftContent())
    }
}

struct SettingContainer: View {
    let title: String
    let data: [SettingRowData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.mutedForeground)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, row in
                    HStack(spacing: 6) {
                        Image(systemName: row.icon)
                            .font(.system(size: 18))
                            .frame(width: 24, height: 24)
                        Text(row.title)
                            .font(.system(size: 15).weight(.medium))
                            .foregroundStyle(.cardForeground)
                        Spacer()
                        row.leftContent
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    if (index < data.count - 1) {
                        Divider()
                    }
                }
            }
            .background(.card)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.bottom, 20)
        }
    }
}
