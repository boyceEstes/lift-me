//
//  ExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct ExerciseRecord: Equatable, Hashable {
    
    public let id: UUID
    
    // relationships
    public var setRecords: [SetRecord]
    public let exercise: Exercise
    
    
    public init(id: UUID, setRecords: [SetRecord], exercise: Exercise) {
        
        self.id = id
        self.setRecords = setRecords
        self.exercise = exercise
    }
}
