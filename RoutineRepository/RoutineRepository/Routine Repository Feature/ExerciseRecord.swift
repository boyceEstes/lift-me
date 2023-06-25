//
//  ExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct ExerciseRecord: Equatable, Hashable {
    
    public let id: UUID
    
    // TODO: 0.1.0 - Create a date completed to show in Exercise Details when the exercise record was done
    // This can be the same date as the routine record completion date
    
    // relationships
    public var setRecords: [SetRecord]
    public let exercise: Exercise
    
    
    public init(id: UUID, setRecords: [SetRecord], exercise: Exercise) {
        
        self.id = id
        self.setRecords = setRecords
        self.exercise = exercise
    }
}
