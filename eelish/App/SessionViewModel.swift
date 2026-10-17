import SwiftUI
import Combine

@MainActor
final class SessionViewModel: ObservableObject {
    enum State {
        case loading
        case authenticated
        case unauthenticated
    }

    @Published private(set) var state: State = .loading

    private let tokenStore: any TokenStoreProtocol
    private let authRepository: AuthRepositoryProtocol

    init(tokenStore: any TokenStoreProtocol, authRepository: AuthRepositoryProtocol) {
        self.tokenStore = tokenStore
        self.authRepository = authRepository
    }

    func checkSession() {
        if tokenStore.accessToken != nil {
            state = .authenticated
        } else {
            state = .unauthenticated
        }
    }

    func logout() async {
        // Báo server thu hồi token, lỗi cũng bỏ qua (best-effort)
        try? await authRepository.logout(request: LogoutRequest(refreshToken: tokenStore.refreshToken ?? ""))

        // Luôn dọn local, dù server thành công hay không
        tokenStore.clear()
        state = .unauthenticated
    }

    func didLogin() {
        state = .authenticated
    }
}
