import SwiftUI

struct TodayScreen : View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Header()
                    SummaryCard(onStudy: {
                        appState.isStudying = true
                    })
                    NeedsAttention()
                    HStack(spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("14-day streak")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                            
                            Text("Best: 21 days · Study every day to keep going!")
                                .font(.caption)
                                .foregroundStyle(.mutedForeground)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(
                        color: .black.opacity(0.06),
                        radius: 3,
                        x: 0,
                        y: 1
                    )
                }
                .padding(.horizontal)
                .padding(.top, geometry.safeAreaInsets.top + 16)
                .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
            }
            .background(Color.background)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TodayScreen()
}
