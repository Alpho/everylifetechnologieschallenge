//
//  Task+CoreDataClass.swift
//  Tasks
//
//  Created by Adam Lingham on 06/06/2021.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

class Task: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case taskDescription = "description"
        case type
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        taskDescription = try container.decode(String.self, forKey: .taskDescription)
        type = try container.decode(String.self, forKey: .type)
    }
}
