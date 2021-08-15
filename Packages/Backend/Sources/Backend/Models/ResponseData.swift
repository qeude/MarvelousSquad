//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import Foundation

public struct RootData<T: Decodable>: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: [T]
}

public struct ResponseData<T: Decodable>: Decodable {
    public var data: RootData<T>
}
