import SwiftUI

struct ProgressBar: View {
    let progress: CGFloat
    var size: CGFloat = 4
    var color: Color = .green

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(Color.muted)

                RoundedRectangle(cornerRadius: .infinity)
                    .fill(color)
                    .frame(width: geometry.size.width * min(max(progress, 0), 1))
            }
        }
        .frame(height: size)
    }
}

#Preview {
    ProgressBar(progress: 0.8)
        .padding()
}
