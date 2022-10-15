//
//  LocalRoutine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalRoutine: Equatable {

    public let id: UUID
    public let name: String
    public let creationDate: Date
    
    // relationships
    public let exercises: [LocalExercise]
    public let routineRecords: [LocalRoutineRecord]
    
    
    public init(id: UUID, name: String, creationDate: Date, exercises: [LocalExercise], routineRecords: [LocalRoutineRecord]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.exercises = exercises
        self.routineRecords = routineRecords
    }
    
}
