import Foundation

final class AppContainer {
    // Dependencies dùng chung (singleton trong vòng đời app)
    let deckRepository: DeckRepositoryProtocol
    let authRepository: AuthRepositoryProtocol
    let tokenStore: TokenStoreProtocol
    // let orderRepository: OrderRepositoryProtocol
    
    init(deckRepository: DeckRepositoryProtocol, authRepository: AuthRepositoryProtocol, tokenStore: any TokenStoreProtocol) {
        self.deckRepository = deckRepository
        self.authRepository = authRepository
        self.tokenStore = tokenStore
    }
    
    // MARK: - Composition root: nơi DUY NHẤT lắp object thật
    static func live(
        environment: AppEnvironment = .current,
        tokenStore: TokenStoreProtocol = KeychainTokenStore()
    ) -> AppContainer {
        let client = APIClient(
            baseURL: environment.baseURL,
            tokenProvider: { tokenStore.accessToken }
        )
        return AppContainer(
            deckRepository: DeckRepository(client: client),
            authRepository: AuthRepository(client: client, tokenStore: tokenStore),
            tokenStore: tokenStore
        )
    }
    
    // MARK: - Factory: mỗi màn hình một hàm
    @MainActor
    func makeDeckViewModel() -> DeckViewModel {
        DeckViewModel(repository: deckRepository)
    }
    
    @MainActor
    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(repository: authRepository)
    }
    
    @MainActor
    func makeSigninViewModel() -> SigninViewModel {
        SigninViewModel(repository: authRepository)
    }
    
    @MainActor
    func makeSessionViewModel() -> SessionViewModel {
        SessionViewModel(tokenStore: tokenStore, authRepository: authRepository)
    }
}
