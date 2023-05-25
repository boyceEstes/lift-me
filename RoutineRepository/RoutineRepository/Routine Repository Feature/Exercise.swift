//
//  Exercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct Exercise: Equatable, Hashable {

    public let id: UUID
    public let name: String
    public let creationDate: Date
    
    // relationships
    public let tags: [Tag]
    
    public init(id: UUID, name: String, creationDate: Date, tags: [Tag]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.tags = tags
    }
}
