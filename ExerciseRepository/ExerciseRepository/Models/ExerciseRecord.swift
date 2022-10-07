//
//  ExerciseRecord.swift
//  
//
//  Created by Boyce Estes on 4/13/22.
//

import Foundation

public struct ExerciseRecord: Equatable, Hashable {
    
    public let exerciseRecordID: UUID
    public let dateTime: Date
    
    public let exercise: Exercise
    public let sets: [SetRecord]
    
    public init(exerciseRecordID: UUID, dateTime: Date, exercise: Exercise, sets: [SetRecord]) {
        
        self.exerciseRecordID = exerciseRecordID
        self.dateTime = dateTime
        self.exercise = exercise
        self.sets = sets
    }
}
