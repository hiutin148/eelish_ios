import SwiftUI

struct MockDay: Identifiable {
    let date: Date
    let count: Int

    var id: Date { date }
}

let days: [MockDay] = (0..<210).compactMap { offset in
    guard let date = Calendar.current.date(
        byAdding: .day,
        value: offset - 209,
        to: Calendar.current.startOfDay(for: .now)
    ) else {
        return nil
    }

    return MockDay(
        date: date,
        count: Int.random(in: 0...10)
    )
}

struct StreakChart : View {
    var body: some View {
        let rows = Array(
            repeating: GridItem(.fixed(12), spacing: 4),
            count: 7
        )

        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Study Streak")
                .font(.system(size: 14).weight(.semibold))
                .foregroundStyle(.cardForeground)
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 4) {
                    ForEach(days) { day in
                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.muted.opacity(0.4))
                                .frame(width: 12, height: 12)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(.appPrimary.opacity(Double(day.count)/10.0))
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
            HStack(spacing: 6) {
                Text("Jan → Sep 2026")
                    .font(.system(size: 11))
                    .foregroundStyle(.mutedForeground)
                Spacer()
                Text("Less")
                    .font(.system(size: 11))
                    .foregroundStyle(.mutedForeground)
                ForEach(0..<5, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.muted.opacity(0.4))
                            .frame(width: 12, height: 12)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.appPrimary.opacity(Double(index)/5.0))
                            .frame(width: 12, height: 12)
                    }
                }
                Text("More")
                    .font(.system(size: 11))
                    .foregroundStyle(.mutedForeground)
            }
        }
        .padding(16)
        .background(.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.bottom, 16)
    }
}
