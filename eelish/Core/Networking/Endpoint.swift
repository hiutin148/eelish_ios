import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

struct Endpoint {
    let path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var body: Encodable? = nil
    var headers: [String: String] = [:]

    func makeRequest(baseURL: URL) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else { throw APIError.invalidRequest }

        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { throw APIError.invalidRequest }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }
        return request
    }
}

private struct AnyEncodable: Encodable {
    let value: Encodable
    init(_ value: Encodable) { self.value = value }
    func encode(to encoder: Encoder) throws { try value.encode(to: encoder) }
}
