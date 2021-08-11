//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import Combine
import Foundation

public final class StoreProvider: StoreProviderProtocol {
    private let networkProvider: NetworkProviderProtocol
    public let persistentContainer: PersistentContainer
    private let jsonDecoder: JSONDecoder

    public init(networkProvider: NetworkProviderProtocol, inMemory: Bool = false) {
        self.networkProvider = networkProvider
        persistentContainer = PersistentContainer(name: "MarvelousSquad", bundle: .module, inMemory: inMemory)
        jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo[CodingUserInfoKey.managedObjectContext] = persistentContainer.viewContext
    }

    public func listSuperheroes() -> AnyPublisher<[Superhero], Error> {
        guard
            let listSuperheroesRequest = URLRequest.createRequest(
                for: .listSuperheroes
            )
        else {
            return Empty<[Superhero], Error>(
                completeImmediately: true
            )
            .eraseToAnyPublisher()
        }

        return networkProvider.request(
            listSuperheroesRequest,
            type: ResponseData<Superhero>.self,
            queue: .main,
            retries: 0,
            jsonDecoder: jsonDecoder
        )
        .map(\.data.results)
        .eraseToAnyPublisher()
    }
}
