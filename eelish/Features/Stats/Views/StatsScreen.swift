import SwiftUI
import Charts



struct StatsScreen : View {

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    StatsHeader()
                    VStack(alignment: .leading, spacing: 0) {
                        StatSummaryGrid()
                        StreakChart()
                        WeeklyReview()
                        CardMastery()
                        WeeklyForecast()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .frame(width: geometry.size.width)
            .background(Color.background)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    StatsScreen()
}
