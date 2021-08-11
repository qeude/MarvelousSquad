//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import Combine
import Foundation

public protocol NetworkProviderProtocol {
    var session: URLSession { get set }

    func request<T>(_ request: URLRequest, type: T.Type, queue: DispatchQueue, retries: Int, jsonDecoder: JSONDecoder) -> AnyPublisher<T, Error> where T: Decodable
}
