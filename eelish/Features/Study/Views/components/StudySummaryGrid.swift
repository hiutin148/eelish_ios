import SwiftUI


struct StudySummaryGrid : View {
    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                StudySummaryCard(title: "Reviewed", desc: "cards this session") {
                    Text("26")
                        .font(.system(size: 26).weight(.heavy))
                        .foregroundStyle(.appPrimary)
                }
                StudySummaryCard(title: "Accuracy", desc: "25 good · 5 again") {
                    Text("87%")
                        .font(.system(size: 26).weight(.heavy))
                        .foregroundStyle(.good)
                }
            }
            GridRow {
                StudySummaryCard(title: "Time", desc: "avg 24s per card") {
                    Text("48m")
                        .font(.system(size: 26).weight(.heavy))
                        .foregroundStyle(.hard)
                }
                StudySummaryCard(title: "Streak", desc: "days in a row") {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.hard)
                        Text("14")
                            .font(.system(size: 26).weight(.heavy))
                            .foregroundStyle(.again)
                    }
                }
            }
        }
        .padding(.bottom, 16)
    }
}
