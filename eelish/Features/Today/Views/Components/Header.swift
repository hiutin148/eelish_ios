import SwiftUI

struct Header : View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Text("Good morning, Minh")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.mutedForeground)
                    Image(systemName: "hand.wave.fill")
                        .foregroundStyle(.yellow)
                }
                Text("Today")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
            }
            Spacer()
            HStack(spacing: 2) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("14")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.card, in: RoundedRectangle(cornerRadius: .infinity))
            .overlay {
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(.border, lineWidth: 1)
            }
            .shadow(
                color: .black.opacity(0.06),
                radius: 3,
                x: 0,
                y: 1
            )
        }.padding(.bottom, 12)
    }
}

#Preview {
    Header()
}
