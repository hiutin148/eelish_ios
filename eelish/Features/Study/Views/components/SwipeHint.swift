import SwiftUI

struct SwipeHint: View {
    let icon: String
    let title: String
    let color: Color
    var iconTrailing = false

    var body: some View {
        HStack(spacing: 0) {
            if !iconTrailing { Image(systemName: icon) }
            Text(title)
            if iconTrailing { Image(systemName: icon) }
        }
        .font(.system(size: 11).weight(.semibold))
        .foregroundStyle(color)
    }
}

