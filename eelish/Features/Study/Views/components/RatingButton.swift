import SwiftUI

struct RatingButton: View {
    let rating: Rating
    let interval: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: rating.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
                    
                Text(rating.title)
                    .font(.caption.bold())
                    .foregroundStyle(rating.color)
                Text(interval)
                    .font(.system(size: 10))
                    .foregroundStyle(rating.color.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(
            .app(
                .outline,
                background: rating.color.opacity(0.094),
                borderColor: rating.color.opacity(0.25)
            )
        )
        .frame(maxWidth: .infinity)
    }
}
