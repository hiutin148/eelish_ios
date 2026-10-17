import SwiftUI

extension Rating {
    init(dx: CGFloat, dy: CGFloat) {
        if abs(dy) > abs(dx) {
            self = dy > 0 ? .hard : .easy
        } else {
            self = dx < 0 ? .again : .good
        }
    }

    var isVertical: Bool { self == .hard || self == .easy }

    func threshold(in size: CGSize) -> CGFloat {
        (isVertical ? size.height : size.width) / 3
    }
}

struct WordCardComponent: View {
    let word: Word
    @Binding var swipeCommand: Rating?
    let onSwiped: (Rating) -> Void

    @State private var offset: CGSize = .zero
    @State private var rotateDeg: CGFloat = 0
    @State private var overlayOpacity: CGFloat = 0
    @State private var overlayColor: Color = .clear
    @State private var removeThreshold: CGFloat = .infinity
    @State private var direction: Rating?
    @State private var isSwiping = false

    @State private var flipRotation: Double = 0

    private let maxDegree: CGFloat = 60

    var body: some View {
        GeometryReader { geometry in
            FlipContainer(rotation: flipRotation) {
                cardFace(background: .card) {
                    Text(word.text)
                        .font(.system(size: 36, weight: .bold))
                }
            } back: {
                cardFace(background: .green) {
                    Text("Nghĩa của từ")
                        .font(.title2)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .fill(overlayColor)
                    .opacity(overlayOpacity)
            }
            .rotationEffect(.degrees(rotateDeg))
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isSwiping else { return }
                        let dx = value.translation.width
                        let dy = value.translation.height
                        let rating = Rating(dx: dx, dy: dy)

                        direction = rating
                        overlayColor = rating.color
                        removeThreshold = rating.threshold(in: geometry.size)
                        overlayOpacity = rating.isVertical
                            ? abs(dy) / geometry.size.height
                            : abs(dx) / geometry.size.width
                        offset = value.translation
                        rotateDeg = (dx / geometry.size.width) * maxDegree
                    }
                    .onEnded { value in
                        guard !isSwiping, let rating = direction else { return }

                        let predicted = rating.isVertical
                            ? value.predictedEndTranslation.height
                            : value.predictedEndTranslation.width

                        if abs(predicted) > removeThreshold {
                            flyOut(rating, in: geometry.size, from: value.translation)
                        } else {
                            withAnimation(.spring) {
                                offset = .zero
                                rotateDeg = 0
                                overlayOpacity = 0
                            }
                            overlayColor = .clear
                            removeThreshold = .infinity
                            direction = nil
                        }
                    }
            )
            .onTapGesture {
                guard !isSwiping else { return }
                withAnimation(.easeInOut(duration: 0.6)) {
                    flipRotation += 180
                }
            }
            .onChange(of: swipeCommand) { _, rating in
                guard let rating else { return }
                swipeCommand = nil
                flyOut(rating, in: geometry.size)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    @ViewBuilder
    private func cardFace<Content: View>(
        background: some ShapeStyle,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack { content() }
            .padding(32)
            .frame(maxWidth: .infinity)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func flyOut(_ rating: Rating, in size: CGSize, from translation: CGSize = .zero) {
        guard !isSwiping else { return }
        isSwiping = true

        let w = size.width * 1.5
        let h = size.height * 1.5
        overlayColor = rating.color

        withAnimation(.easeOut(duration: 0.5)) {
            overlayOpacity = 0.6
            switch rating {
            case .good:
                offset = CGSize(width: w, height: translation.height)
                rotateDeg = maxDegree
            case .again:
                offset = CGSize(width: -w, height: translation.height)
                rotateDeg = -maxDegree
            case .hard:
                offset = CGSize(width: translation.width, height: h)
            case .easy:
                offset = CGSize(width: translation.width, height: -h)
            }
        } completion: {
            onSwiped(rating)
        }
    }
}

struct FlipContainer<Front: View, Back: View>: View, Animatable {
    var rotation: Double
    let front: Front
    let back: Back

    init(rotation: Double,
         @ViewBuilder front: () -> Front,
         @ViewBuilder back: () -> Back) {
        self.rotation = rotation
        self.front = front()
        self.back = back()
    }

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    var body: some View {
        let normalized = rotation.truncatingRemainder(dividingBy: 360)
        let isShowingFront = abs(normalized) < 90 || abs(normalized) > 270

        ZStack {
            if isShowingFront {
                front
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            } else {
                back
                    .rotation3DEffect(.degrees(rotation - 180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
}

#Preview {
    StudyScreen()
}
