import SwiftUI
import Charts

struct WeeklyStat: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

struct WeeklyReview : View {
    private let data: [WeeklyStat] = [
        .init(day: "Mon", count: 12),
        .init(day: "Tue", count: 18),
        .init(day: "Wed", count: 8),
        .init(day: "Thu", count: 25),
        .init(day: "Fri", count: 15),
        .init(day: "Sat", count: 30),
        .init(day: "Sun", count: 20)
    ]
    
    func isToday(_ label: String) -> Bool {
        let today = Date.now

        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"

        let todayLabel = formatter.string(from: today)
        
        return todayLabel.lowercased() == label.lowercased()
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Reviews this week")
                    .font(.system(size: 14).weight(.semibold))
                    .foregroundStyle(.cardForeground)
                Spacer()
                Text("196 total")
                    .font(.system(size: 14).weight(.semibold))
                    .foregroundStyle(.appPrimary)
            }
            Chart(data) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Words", item.count),
                    width: .ratio(0.9)
                )
                .foregroundStyle(isToday(item.day) ? .appPrimary : .appPrimary.opacity(0.4))
                .cornerRadius(24)
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel()
                }
            }
            .frame(height: 160)
        }
        .padding(16)
        .background(.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.bottom, 16)
    }
}
