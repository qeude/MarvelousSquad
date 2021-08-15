//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import Combine
import Foundation

public protocol StoreProviderProtocol {
    var persistentContainer: PersistentContainer { get }

    func listSuperheroes(with offset: Int) -> AnyPublisher<RootData<Superhero>, Error>
}
