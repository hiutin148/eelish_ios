import SwiftUI


struct StatSummaryGrid : View {
    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                StatSummaryCard(title: "Words Mastered", desc: "+18 this week") {
                    Text("26")
                        .font(.system(size: 26).weight(.heavy))
                        .foregroundStyle(.appPrimary)
                }
                StatSummaryCard(title: "Retention Rate", desc: "+3% vs last month") {
                    Text("87%")
                        .font(.system(size: 26).weight(.heavy))
                        .foregroundStyle(.good)
                }
            }
            GridRow {
                StatSummaryCard(title: "Study Time", desc: "Avg 22min/day") {
                    Text("48h")
                        .font(.system(size: 26).weight(.heavy))
                        .foregroundStyle(.hard)
                }
                StatSummaryCard(title: "Best Streak", desc: "Current: 14 days") {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.hard)
                        Text("21")
                            .font(.system(size: 26).weight(.heavy))
                            .foregroundStyle(.again)
                    }
                }
            }
        }
        .padding(.bottom, 16)
    }
}
