import SwiftUI

struct TextChip : View {
    var label: String
    var color: Color
    var background: Color
    
    var body: some View {
        Text(
            label
        )
        .font(.caption.weight(.semibold))
        .foregroundStyle(color)
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
    }
}
