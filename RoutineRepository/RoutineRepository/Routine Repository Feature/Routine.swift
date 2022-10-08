//
//  Routine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct Routine {

    public let id: UUID
    public let creationDate: Date
    
    // relationships
    public let exercises: [Exercise]
    public let routineRecords: [RoutineRecord]
    
    public init(id: UUID, creationDate: Date, exercises: [Exercise], routineRecords: [RoutineRecord]) {
        self.id = id
        self.creationDate = creationDate
        self.exercises = exercises
        self.routineRecords = routineRecords
    }
}
