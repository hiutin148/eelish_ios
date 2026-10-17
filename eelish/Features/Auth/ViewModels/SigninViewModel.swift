import Foundation
import Combine

@MainActor
final class SigninViewModel: ObservableObject {
    enum State : Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: State = .idle

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func signin(
        email: String,
        password: String
    ) async {
        guard case .loading = state else {
            state = .loading
            do {
                _ = try await repository.signin(
                    request: SigninRequest(
                        email: email,
                        password: password
                    )
                )
                state = .loaded
            } catch is CancellationError {
                state = .idle
            } catch {
                state = .failed(error.localizedDescription)
            }
            return
        }
    }
}
