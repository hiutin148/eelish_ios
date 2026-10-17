import SwiftUI

struct FlipCard: View {
    @State private var rotation: Double = 0
    @State private var offset: CGSize = .zero
    private let limitThreshold: CGFloat = 300
    @State private var cardWidth: CGFloat = 0
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.6)) {
                rotation += 180
            }
        } label: {
            FlipCardContent(rotation: rotation)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear { cardWidth = geo.size.width }
                            .onChange(of: geo.size.width, {_, newValue in
                                cardWidth = newValue
                            })
                    }
                )
                .offset(offset)
                .rotationEffect(.degrees(offset.width * 0.06))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let halfCardWidth = cardWidth / 2
                            let raw = value.translation.width
                            let clampedWidth: CGFloat
                            if abs(raw) <= halfCardWidth {
                                clampedWidth = raw
                            } else {
                                let extra = abs(raw) - halfCardWidth
                                let resisted = halfCardWidth + extra / (1 + extra / halfCardWidth)
                                clampedWidth = raw < 0 ? -resisted : resisted
                            }
                            offset = CGSize(
                                width: clampedWidth,
                                height: clampedWidth < 0 ? -clampedWidth / 8 : clampedWidth / 8
                            )
                        }
                        .onEnded { value in
                            let halfCardWidth = cardWidth / 2
                            if abs(value.translation.width) > halfCardWidth {
                                withAnimation(.spring()) {
                                    offset = CGSize(width: value.translation.width > 0 ? 500 : -500, height: 0)
                                }
                            } else {
                                withAnimation(.spring()) { offset = .zero }
                            }
                        }
                )
        }
        .buttonStyle(.plain)
    }
}

struct FlipCardContent: View, Animatable {
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var body: some View {
        let normalized = rotation.truncatingRemainder(dividingBy: 360)
        let isShowingFront = abs(normalized) < 90 || abs(normalized) > 270
        
        ZStack {
            if isShowingFront {
                WordCard(isFront: true)
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            } else {
                WordCard(isFront: false)
                    .rotation3DEffect(.degrees(rotation - 180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
}

struct WordCard : View {
    let isFront: Bool
    var body: some View {
        VStack {
            Text("Noun".uppercased())
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
                .padding(.bottom, 24)
            Text("Productivity")
                .font(.system(size: 36))
                .fontWeight(.bold)
                .padding(.bottom, 12)
            Text("The new software increased team productivity by 40%.")
                .font(.system(size: 14))
                .foregroundStyle(Color.mutedForeground)
            HStack(spacing: 8) {
                Text("Tap to reveal")
                    .font(.caption)
                    .foregroundStyle(Color.mutedForeground)
                Image(systemName: "arrow.down")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.mutedForeground)
                    .padding(8)
                    .background(Color(hex: "#E4E8F0"))
                    .clipShape(Circle())
            }
            .padding(.top, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(isFront ? .white : .green)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.12),radius: 4, x: 0, y: 0)
        .padding(.horizontal, 20)
    }
}

#Preview {
    CardsScreen(deckId: "1")
}
