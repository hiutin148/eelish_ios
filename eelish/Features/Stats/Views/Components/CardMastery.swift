import SwiftUI

struct CardMastery : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Card Mastery")
                .font(.system(size: 14).weight(.semibold))
                .foregroundStyle(.cardForeground)
                .padding(.bottom, 12)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Mastered")
                            .font(.system(size: 13).weight(.medium))
                            .foregroundStyle(.cardForeground)
                        Spacer()
                        Text("342 / 1000")
                            .font(.system(size: 13))
                            .foregroundStyle(.mutedForeground)
                    }
                    ProgressBar(progress: 0.6, color: .good)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Learning")
                            .font(.system(size: 13).weight(.medium))
                            .foregroundStyle(.cardForeground)
                        Spacer()
                        Text("342 / 1000")
                            .font(.system(size: 13))
                            .foregroundStyle(.mutedForeground)
                    }
                    ProgressBar(progress: 0.6, color: .hard)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("New")
                            .font(.system(size: 13).weight(.medium))
                            .foregroundStyle(.cardForeground)
                        Spacer()
                        Text("342 / 1000")
                            .font(.system(size: 13))
                            .foregroundStyle(.mutedForeground)
                    }
                    ProgressBar(progress: 0.6, color: .easy)
                }
            }
        }
        .padding(16)
        .background(.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.bottom, 16)
    }
}
