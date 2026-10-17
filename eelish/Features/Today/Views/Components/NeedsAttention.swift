import SwiftUI

struct MockDeck: Identifiable {
    let id: String
    let name: String
    let total: Int
    let new: Int
    let learning: Int
    let mastered: Int
    let due: Int
    let color: String

    static let samples: [MockDeck] = [
        MockDeck(
            id: "1",
            name: "TOEIC 600 Essential",
            total: 600,
            new: 48,
            learning: 94,
            mastered: 342,
            due: 24,
            color: "#4F46E5"
        ),
        MockDeck(
            id: "2",
            name: "Business English",
            total: 240,
            new: 20,
            learning: 58,
            mastered: 148,
            due: 12,
            color: "#0891B2"
        ),
        MockDeck(
            id: "3",
            name: "Office & HR",
            total: 120,
            new: 10,
            learning: 22,
            mastered: 78,
            due: 8,
            color: "#059669"
        ),
        MockDeck(
            id: "4",
            name: "Finance & Accounting",
            total: 180,
            new: 30,
            learning: 30,
            mastered: 62,
            due: 5,
            color: "#D97706"
        ),
        MockDeck(
            id: "5",
            name: "Travel & Logistics",
            total: 96,
            new: 0,
            learning: 12,
            mastered: 60,
            due: 0,
            color: "#7C3AED"
        )
    ]
}

struct NeedsAttention : View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("NEEDS ATTENTION")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.mutedForeground)
                .padding(.bottom, 10)
            LazyVStack(alignment: .leading) {
                ForEach(Array(MockDeck.samples.enumerated()), id: \.element.id) {index, deck in
                    HStack {
                        Circle()
                            .fill(Color(hex: deck.color))
                            .frame(width: 4, height: 4)
                        Text(deck.name)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        Text("\(deck.due) due")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .background(Color(hex: deck.color))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    
                    if index < MockDeck.samples.count - 1 {
                        Divider()
                    }
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    NeedsAttention()
}
