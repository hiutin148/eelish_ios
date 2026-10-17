import Foundation
import Combine
import SwiftUI

@MainActor
final class DeckViewModel : ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case failed(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published var decks: [Deck] = []
    @Published var decksTree: [TreeNode] = []
    
    private let repository: DeckRepositoryProtocol
    
    init(repository: DeckRepositoryProtocol) {
        self.repository = repository
    }
    
    func load() async {
        state = .loading
        do {
            let decksRes = try await repository.getDecks()
            decks = decksRes.data?.content ?? []
            state = .loaded
        } catch is CancellationError {
            // View biến mất, bỏ qua
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func loadTree() async {
        state = .loading
        do {
            let decksRes = try await repository.getDecksTree()
            decksTree = decksRes.data ?? []
            state = .loaded
        } catch is CancellationError {
            // View biến mất, bỏ qua
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
