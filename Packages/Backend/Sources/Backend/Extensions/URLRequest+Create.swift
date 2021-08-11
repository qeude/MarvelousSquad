//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import CommonCrypto
import Foundation
public extension URLRequest {
    enum Endpoint {
        private static let baseURL = "https://gateway.marvel.com:443/"

        case listSuperheroes

        fileprivate var urlString: String {
            switch self {
            case .listSuperheroes:
                return "\(Endpoint.baseURL)v1/public/characters"
            }
        }
    }

    static func createRequest(for endpoint: Endpoint) -> URLRequest? {
        guard var components = URLComponents(string: endpoint.urlString) else {
            return nil
        }
        let publicKey = "***REMOVED***"
        let privateKey = "***REMOVED***"
        let ts = "\(Date().timeIntervalSince1970)"
        let apiKeyQueryItem = URLQueryItem(name: "apikey", value: publicKey)
        let tsQueryItem = URLQueryItem(name: "ts", value: ts)
        let hashQueryItem = URLQueryItem(name: "hash", value: "\(ts)\(privateKey)\(publicKey)".md5)

        components.queryItems = [apiKeyQueryItem, tsQueryItem, hashQueryItem]

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("MarvelousSquad/1.0", forHTTPHeaderField: "User-Agent")

        return request
    }
}

extension String {
    var md5: String {
        let data = Data(utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
