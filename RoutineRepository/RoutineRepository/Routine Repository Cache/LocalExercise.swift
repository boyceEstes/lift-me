//
//  LocalExercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalExercise: Equatable {

    public let id: UUID
    public let name: String
    public let creationDate: Date
    
    // relationships
    public let exerciseRecords: [LocalExerciseRecord]
    public let tags: [LocalTag]
    
    
    public init(id: UUID, name: String, creationDate: Date, exerciseRecords: [LocalExerciseRecord], tags: [LocalTag]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.exerciseRecords = exerciseRecords
        self.tags = tags
    }
    
}
