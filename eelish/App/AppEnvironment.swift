import Foundation

enum AppEnvironment {
    case dev, staging, prod

    var baseURL: URL {
        switch self {
        case .dev:     return URL(string: "http://localhost:8080/")!
        case .staging: return URL(string: "http://localhost:8080/")!
        case .prod:    return URL(string: "http://localhost:8080/")!
        }
    }

    static var current: AppEnvironment {
        #if DEBUG
        return .dev
        #else
        return .prod
        #endif
    }
}

