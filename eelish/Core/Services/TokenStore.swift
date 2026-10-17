
import Foundation
import Security

protocol TokenStoreProtocol {
    var accessToken: String? { get }
    var refreshToken: String? { get }

    func save(accessToken: String, refreshToken: String)
    func clear()
}

struct KeychainTokenStore: TokenStoreProtocol {
    private let service = Bundle.main.bundleIdentifier ?? "com.hiutin.eelish"

    var accessToken: String? {
        read(account: "access_token")
    }

    var refreshToken: String? {
        read(account: "refresh_token")
    }

    func save(accessToken: String, refreshToken: String) {
        write(accessToken, account: "access_token")
        write(refreshToken, account: "refresh_token")
    }

    func clear() {
        delete(account: "access_token")
        delete(account: "refresh_token")
    }

    private func baseQuery(account: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    private func read(account: String) -> String? {
        var query = baseQuery(account: account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: CFTypeRef?

        guard SecItemCopyMatching(
            query as CFDictionary,
            &result
        ) == errSecSuccess,
        let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    private func write(_ token: String, account: String) {
        let query = baseQuery(account: account)
        let data = Data(token.utf8)

        let status = SecItemUpdate(
            query as CFDictionary,
            [kSecValueData as String: data] as CFDictionary
        )

        guard status == errSecItemNotFound else {
            return
        }

        var newQuery = query
        newQuery[kSecValueData as String] = data
        newQuery[kSecAttrAccessible as String] =
            kSecAttrAccessibleAfterFirstUnlock

        SecItemAdd(newQuery as CFDictionary, nil)
    }

    private func delete(account: String) {
        SecItemDelete(baseQuery(account: account) as CFDictionary)
    }
}

final class MockTokenStore: TokenStoreProtocol {
    var accessToken: String?
    var refreshToken: String?

    init(
        accessToken: String? = "mock-access-token",
        refreshToken: String? = "mock-refresh-token"
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func save(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
