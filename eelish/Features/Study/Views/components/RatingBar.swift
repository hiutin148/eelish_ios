import SwiftUI

enum Rating: CaseIterable {
    case again, hard, good, easy

    var title: String {
        switch self {
        case .again: "Again"
        case .hard:  "Hard"
        case .good:  "Good"
        case .easy:  "Easy"
        }
    }

    var icon: String {
        switch self {
        case .again: "xmark"
        case .hard:  "moonphase.first.quarter.inverse"
        case .good:  "checkmark"
        case .easy:  "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .again: .again
        case .hard:  .hard
        case .good:  .good
        case .easy:  .easy
        }
    }
}

struct RatingBar: View {
    let intervals: [Rating: String]
    let onSelect: (Rating) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Rating.allCases, id: \.self) { rating in
                RatingButton(rating: rating, interval: intervals[rating] ?? "") {
                    onSelect(rating)
                }
            }
        }
    }
}
