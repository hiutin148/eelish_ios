protocol AuthRepositoryProtocol {
    func signup(request: SignupRequest) async throws -> Bool
    func signin(request: SigninRequest) async throws -> Bool
    func logout(request: LogoutRequest) async throws -> Bool
}

final class AuthRepository: AuthRepositoryProtocol {
    private let client: APIClient
    private let tokenStore: any TokenStoreProtocol
    
    init(client: APIClient, tokenStore: any TokenStoreProtocol) {
        self.client = client
        self.tokenStore = tokenStore
    }
    
    func signup(request: SignupRequest) async throws -> Bool {
        let res: ApiResponseDto<SignupResponse> =
            try await client.send(
                Endpoint(path: "register", method: .post, body: request)
            )
        return res.success
    }
    
    func signin(request: SigninRequest) async throws -> Bool {
        let res: ApiResponseDto<SigninResponse> =
            try await client.send(
                Endpoint(path: "signin", method: .post, body: request)
            )
        if res.data == nil || res.data?.accessToken == nil || res.data?.refreshToken == nil {
            return false
        }
        tokenStore.save(accessToken: res.data!.accessToken, refreshToken: res.data!.accessToken)
        return res.success
    }
    
    func logout(request: LogoutRequest) async throws -> Bool {
        let res: ApiResponseDto<EmptyResponse?> =
            try await client.send(
                Endpoint(path: "logout", method: .post)
            )
        return res.success
    }
}

