//
//  LocalRoutine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalRoutine: Equatable {

    let id: UUID
    let name: String
    let creationDate: Date
    
    // relationships
    let exercises: [LocalExercise]
    let routineRecords: [LocalRoutineRecord]
    
    
    public init(id: UUID, name: String, creationDate: Date, exercises: [LocalExercise], routineRecords: [LocalRoutineRecord]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.exercises = exercises
        self.routineRecords = routineRecords
    }
    
}
