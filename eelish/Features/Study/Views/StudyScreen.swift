import SwiftUI

struct Word: Identifiable {
    let id: Int
    let text: String
}

struct StudyScreen: View {
    @Environment(\.dismiss) private var dismiss
    private let intervals: [Rating: String] = [
        .again: "10m", .hard: "1d", .good: "4d", .easy: "7d"
    ]
    
    @State private var words: [Word] = (1...8).map { Word(id: $0, text: "Word \($0)") }
    @State private var index = 0
    @State private var reviewed: [Int: Rating] = [:]
    @State private var swipeCommand: Rating?
    
    private var visibleWords: [Word] {
        Array(words[index...].prefix(3))
    }
    
    var body: some View {
        VStack {
            StudyHeader(
                progress: Double(index) / Double(words.count),
                current: min(index + 1, words.count),
                total: words.count
            ) {
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            SwipeHintsRow()
                .padding(.horizontal, 40)
                .padding(.bottom, 12)
            
            Spacer()
            
            ZStack {
                if index >= words.count {
                    Text("Hoàn thành!")
                } else {
                    ForEach(Array(visibleWords.enumerated()).reversed(), id: \.element.id) { depth, word in
                        WordCardComponent(
                            word: word,
                            swipeCommand: depth == 0 ? $swipeCommand : .constant(nil)
                        ) { rating in
                            withAnimation { rate(rating) }
                        }
                        .padding(.horizontal, 20)
                        .scaleEffect(1 - 0.05 * CGFloat(depth))
                        .offset(y: 12 * CGFloat(depth))
                        .allowsHitTesting(depth == 0)
                    }
                }
            }
            Spacer()
            
            SwipeHint(icon: "arrow.down", title: "Hard", color: .hard)
                .opacity(0.55)
                .padding(.horizontal, 40)
            
            RatingBar(intervals: intervals) { rating in
                swipeCommand = rating
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color.background)
    }
    
    private func rate(_ rating: Rating) {
        guard index < words.count else { return }
        reviewed[words[index].id] = rating
        index += 1
        
    }
}

#Preview {
    StudyScreen()
}
