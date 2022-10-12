//
//  Routine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct Routine: Equatable {

    public let id: UUID
    public let name: String
    public let creationDate: Date
    
    // relationships
    public let exercises: [Exercise]
    public let routineRecords: [RoutineRecord]
    
    public init(id: UUID, name: String, creationDate: Date, exercises: [Exercise], routineRecords: [RoutineRecord]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.exercises = exercises
        self.routineRecords = routineRecords
    }
}
