import SwiftUI

enum DeckRoute: Hashable {
    case detail(deckId: String)
}

struct DeckScreen : View {
    @StateObject private var vm : DeckViewModel
    @State private var path = NavigationPath()
    init(viewModel: @autoclosure @escaping () -> DeckViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }
    @State var draggable: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationDestination(for: DeckRoute.self) { route in
                    switch route {
                    case .detail(let deckId):
                        DeckDetailScreen(deckId)
                            .navigationTitle("Deck detail")
                    }
                }
        }
        
        .task {
            await vm.loadTree()
        }
//        .refreshable {
//            await vm.loadTree()
//        }
    }
    
    @ViewBuilder
    private var content : some View {
        switch vm.state {
        case .idle, .loading:
            ProgressRing(progress: 0.5)
        case .loaded:
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    DecksHeader(draggable: $draggable)
                    DecksSearchBar()
                    DecksTabs()
                    DecksList(
                        decks: $vm.decksTree,
                        onDeckTap: { deckId in
                            path.append(DeckRoute.detail(deckId: deckId))
                        },
                        draggable: $draggable
                    )
                    Spacer()
                }
                .padding(.top, geo.safeAreaInsets.top)
                .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                .background(Color.background)
                .ignoresSafeArea()
            }
        case .failed(let message):
            VStack(spacing: 12) {
                Text(message)
                Button("Thử lại") { Task { await vm.loadTree() } }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeckScreen(viewModel: AppContainer.live().makeDeckViewModel())
    }
    .environment(\.container, .live())
}
