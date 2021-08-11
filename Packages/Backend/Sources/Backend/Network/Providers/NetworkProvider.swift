//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import Combine
import Foundation

public final class NetworkProvider: NetworkProviderProtocol {
    public var session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T>(
        _ request: URLRequest,
        type: T.Type = T.self,
        queue: DispatchQueue = .main,
        retries: Int = 0,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> where T: Decodable {
        return session.dataTaskPublisher(for: request)
            .print()
            .tryCompactMap {
                guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
                    return nil
                }

                return $0.data
            }
            .decode(
                type: type,
                decoder: jsonDecoder
            )
            .receive(
                on: queue
            )
            .retry(retries)
            .eraseToAnyPublisher()
    }
}
