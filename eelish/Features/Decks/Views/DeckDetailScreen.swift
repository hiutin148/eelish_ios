import SwiftUI

struct DeckDetailScreen : View {
    let deckId: String
    init(_ deckId: String) {
        self.deckId = deckId
    }
    @State private var selected = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Deck")
                            .font(.system(size: 13).weight(.medium))
                            .foregroundStyle(.white.opacity(0.7))
                        Text("TOEIC 600 Essential")
                            .font(.system(size: 20).weight(.bold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    ProgressRing(progress: 0.5, color: .card)
                }
                .padding(.bottom, 12)
                HStack {
                    DeckSummaryCard(num: "600", label: "total")
                    DeckSummaryCard(num: "600", label: "new", numColor: Color(hex: "93C5FD"))
                    DeckSummaryCard(num: "600", label: "learn", numColor: Color(hex: "FCD34D"))
                    DeckSummaryCard(num: "600", label: "done", numColor: Color(hex: "86EFAC"))
                }
                .padding(.bottom, 12)
                Button {
                    
                } label: {
                    Text("Study this deck · 12 due")
                        .font(.system(size: 15).weight(.bold))
                }.buttonStyle(.app(.primary, fullWidth: true))
                    .overlay {
                        RoundedRectangle(cornerRadius: .infinity)
                            .fill(.white.opacity(0.18))
                            .allowsHitTesting(false)
                    }
            }
            .padding(20)
            .background(.appPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 20)
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    LazyVStack {
                        ForEach(0..<50, id: \.self) { i in
                            Text("Item \(i)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                    }
                    .background(.white, in: RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 20)
                } header: {
                    Picker("Tab", selection: $selected) {
                        Text("All").tag(0)
                        Text("New").tag(1)
                        Text("Learning").tag(2)
                        Text("Mastered").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(Color.background)
                }
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(Color.background)
        .safeAreaInset(edge: .top, spacing: 0) {
            Color.clear
                .frame(height: 0)
                .background(Color.background)
        }
    }
}

struct DeckSummaryCard : View {
    let num: String
    let label: String
    var numColor: Color = Color.white
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.black.opacity(0.18))
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                VStack(spacing: 4) {
                    Text(num)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(numColor)
                    
                    Text(label)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.card)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .padding(10)
            }
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    DeckDetailScreen("test")
}
