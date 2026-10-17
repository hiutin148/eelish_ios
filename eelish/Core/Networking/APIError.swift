import Foundation

enum APIError: Error {
    case network(Error)
    case invalidResponse
    case invalidRequest
    case decoding(Error)
    case unauthorized
    case server(
        statusCode: Int,
        message: String,
        errorCode: String?
    )
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "Invalid server response"
        case .invalidRequest:
            return "Invalid request"
        case .decoding(let error):
            return error.localizedDescription
        case .unauthorized:
            return "Unauthorized"
        case .server(_, let message, _):
            return message
        }
    }
}
