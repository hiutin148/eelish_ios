import SwiftUI

struct StudyHeader: View {
    let progress: Double
    let current: Int
    let total: Int
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onClose) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.appIconMuted)

            ProgressBar(progress: progress, color: .appPrimary)

            Text("\(current)/\(total)")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.mutedForeground)
        }
    }
}
