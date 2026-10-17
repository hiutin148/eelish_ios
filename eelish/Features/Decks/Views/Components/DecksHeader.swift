import SwiftUI

struct DecksHeader : View {
    @Binding var draggable: Bool
    var body: some View {
        HStack {
            Text("Decks")
                .font(.system(size: 26))
                .fontWeight(.bold)
            Spacer()
            if (draggable) {
                Button {
                    draggable = false
                } label: {
                    Text("Done")
                }
            } else {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(.appPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

