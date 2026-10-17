import SwiftUI

struct CardsScreen : View {
    let deckId: String
    var body: some View {
        VStack {
            ProgressBar(progress: 0.2, size: 10, color: Color.primary)
                .padding(.bottom, 16)
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "arrow.left")
                        .font(.caption)
                        .foregroundStyle(Color.muted)
                        .fontWeight(.medium)
                    Text("Forgot")
                        .font(.caption)
                        .foregroundStyle(Color.muted)
                        .fontWeight(.medium)
                }
                Spacer()
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up")
                        .font(.caption)
                        .foregroundStyle(Color.mutedForeground)
                        .fontWeight(.medium)
                    Text("Skip")
                        .font(.caption)
                        .foregroundStyle(Color.mutedForeground)
                        .fontWeight(.medium)
                }
                Spacer()
                HStack(spacing: 2) {
                    Text("Got it")
                        .font(.caption)
                        .foregroundStyle(Color.primary)
                        .fontWeight(.medium)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(Color.primary)
                        .fontWeight(.medium)
                }
            }
            .opacity(0.5)
            .padding(.horizontal, 28)
            .padding(.bottom, 8)
            Spacer()
            ZStack {
                FlipCard()
                FlipCard()
                FlipCard()
                FlipCard()
                FlipCard()
            }
            Spacer()
            HStack {
                Button {
                    
                }
                label: {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.muted)
                            .fontWeight(.semibold)
                        Text("Forgot")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.muted)
                            .fontWeight(.semibold)
                    }
                }
                .buttonStyle(
                    .app(
                        .primary,
                        size: .large,
                        background: .white
                    )
                )
                Spacer()
                Button {
                    
                }
                label: {
                    Text("Skip")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.mutedForeground)
                        .fontWeight(.semibold)
                }
                .buttonStyle(
                    .app(
                        .primary,
                        size: .large,
                        background: .white
                    )
                )
                Spacer()
                Button {}
                label: {
                    HStack {
                        Text("Got it")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        Image(systemName: "checkmark")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                }
                .buttonStyle(
                    .app(
                        .primary,
                        size: .large,
                        background: Color.primary
                    )
                )
            }.frame(maxWidth: .infinity).padding(.horizontal, 20)
        }.background(Color.background)
    }
}



#Preview {
    CardsScreen(deckId: "1")
}
