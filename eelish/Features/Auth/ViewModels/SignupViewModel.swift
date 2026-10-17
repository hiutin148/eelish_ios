
import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
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

    func signup(
        email: String,
        name: String,
        password: String
    ) async {
        guard case .loading = state else {
            state = .loading
            do {
                _ = try await repository.signup(
                    request: SignupRequest(
                        email: email,
                        name: name,
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
