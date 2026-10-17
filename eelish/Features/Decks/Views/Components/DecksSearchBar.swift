import SwiftUI

struct DecksSearchBar : View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(.mutedForeground)
            Text("Search deck...")
                .font(.system(size: 14))
                .foregroundStyle(.mutedForeground)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(.muted)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.border, lineWidth: 1)
        }
        .padding(.horizontal ,20)
        .padding(.bottom, 12)
    }
}
