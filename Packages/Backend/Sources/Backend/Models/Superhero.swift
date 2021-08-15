//
//  File.swift
//
//
//  Created by Quentin Eude on 11/08/2021.
//

import CoreData
import Foundation

public class Superhero: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case desc = "description"
        case thumbnail
    }

    enum ThumbnailKeys: String, CodingKey {
        case path
        case ext = "extension"
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(Int64.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decode(String.self, forKey: .desc)
        let thumbnailContainer = try container.nestedContainer(keyedBy: ThumbnailKeys.self, forKey: .thumbnail)
        let path = try thumbnailContainer.decode(String.self, forKey: .path)
        let ext = try thumbnailContainer.decode(String.self, forKey: .ext)
        rawThumbnailUrl = "\(path).\(ext)"
    }
}

public extension Superhero {
    var thumbnailUrl: URL? {
        if let url = URL(string: rawThumbnailUrl ?? ""),
           var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        {
            if components.scheme == "http" {
                components.scheme = "https"
            }
            return components.url
        }
        return nil
    }
}
