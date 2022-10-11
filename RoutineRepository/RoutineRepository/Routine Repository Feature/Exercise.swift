//
//  Exercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct Exercise {

    public let id: UUID
    public let name: String
    public let creationDate: Date
    
    // relationships
    public let exerciseRecords: [ExerciseRecord]
    public let tags: [Tag]
    
    public init(id: UUID, name: String, creationDate: Date, exerciseRecords: [ExerciseRecord], tags: [Tag]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.exerciseRecords = exerciseRecords
        self.tags = tags
    }
}
