import SwiftUI

struct StudyCompleteScreen : View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.card)
                        Text("Session complete")
                            .font(.system(size: 24).weight(.heavy))
                            .foregroundStyle(.primaryForeground)
                        Text("TOEIC 600 Essential · 30 cards")
                            .font(.system(size: 14))
                            .foregroundStyle(.primaryForeground.opacity(0.7))
                        ProgressRing(progress: 0.7,size: 60, strokeWidth: 6,)
                            .padding(.top, 20)
                        HStack {
                            Image(systemName: "clock")
                            Text("Next review in 4 hours · 3:00 PM")
                        }
                        .font(.system(size: 13).weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .padding(.top, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(.appPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    StudySummaryGrid()
                    .padding(.horizontal, 20)
                    VStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.easy)
                        
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
    StudyCompleteScreen()
}
