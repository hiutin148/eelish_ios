import SwiftUI

struct QuantityController : View {
    @State private var value: Int = 30
    var body: some View {
        HStack {
            Button {
                value -= 1
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 12).weight(.bold))
                    .frame(width: 18, height: 18)
                    .padding(6)
                    .background(.muted)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
            .buttonStyle(.plain)
            Text("\(value)")
                .font(.system(size: 14).weight(.bold))
            Button {
                value += 1
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 12).weight(.bold))
                    .frame(width: 18, height: 18)
                    .padding(6)
                    .background(.muted)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    QuantityController()
}
