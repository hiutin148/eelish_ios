import Foundation

protocol APIClientProtocol {
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let tokenProvider: () -> String?

    init(
        baseURL: URL,
        session: URLSession = .shared,
        tokenProvider: @escaping () -> String? = { nil }
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = try endpoint.makeRequest(baseURL: baseURL)

        if let token = tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            print(error)
            throw APIError.network(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }

        default:
            let errorResponse = try? decoder.decode(
                ApiResponseDto<EmptyResponse>.self,
                from: data
            )

            if http.statusCode == 401 {
                throw APIError.unauthorized
            }

            throw APIError.server(
                statusCode: http.statusCode,
                message: errorResponse?.message
                    ?? HTTPURLResponse.localizedString(
                        forStatusCode: http.statusCode
                    ),
                errorCode: errorResponse?.errorCode
            )
        }
    }
}
