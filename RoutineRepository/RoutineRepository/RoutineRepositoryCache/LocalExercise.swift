//
//  LocalExercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalExercise: Equatable {

  
    let id: UUID
    let name: String
    let creationDate: Date
    
    // relationships
    let exerciseRecords: [LocalExerciseRecord]
    let tags: [LocalTag]
    
    
    public init(id: UUID, name: String, creationDate: Date, exerciseRecords: [LocalExerciseRecord], tags: [LocalTag]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.exerciseRecords = exerciseRecords
        self.tags = tags
    }
    
}
