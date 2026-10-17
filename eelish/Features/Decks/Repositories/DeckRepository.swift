protocol DeckRepositoryProtocol {
    func getDecks() async throws -> ApiResponseDto<PageResponseDto<Deck>>
    func getDecksTree() async throws -> ApiResponseDto<[TreeNode]> 
}

final class DeckRepository: DeckRepositoryProtocol {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getDecks() async throws -> ApiResponseDto<PageResponseDto<Deck>> {
        try await client.send(Endpoint(path: "items/decks"))
    }
    
    func getDecksTree() async throws -> ApiResponseDto<[TreeNode]> {
        try await client.send(Endpoint(path: "items/decks/tree"))
    }
}
