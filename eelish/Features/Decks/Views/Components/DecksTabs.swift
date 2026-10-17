import SwiftUI

struct DecksTabs : View {
    var body: some View {
        HStack {
            TextChip(label: "1236 total", color: .mutedForeground, background: .muted)
            TextChip(label: "5 due", color: .appPrimary, background: .primaryLight)
            TextChip(label: "108 new", color: .easy, background: .primaryLight)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}
