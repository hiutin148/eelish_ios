import SwiftUI

struct SwipeHintsRow: View {
    var body: some View {
        HStack(spacing: 0) {
            SwipeHint(icon: "arrow.left", title: "Again", color: .again)
            Spacer()
            SwipeHint(icon: "arrow.up", title: "Easy", color: .easy)
            Spacer()
            SwipeHint(icon: "arrow.right", title: "Good", color: .good, iconTrailing: true)
        }
        .opacity(0.55)
    }
}
