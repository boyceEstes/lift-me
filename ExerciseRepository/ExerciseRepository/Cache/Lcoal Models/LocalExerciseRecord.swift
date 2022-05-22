//
//  LocalExerciseRecord.swift
//  
//
//  Created by Boyce Estes on 4/20/22.
//

import Foundation


public struct LocalExerciseRecord: Equatable, Codable {
    
    let exerciseRecordID: UUID
    let dateTime: Date
    
    let exercise: LocalExercise
    let sets: [LocalSetRecord]
}


extension LocalExerciseRecord {
    
    func toModel() -> ExerciseRecord {
        ExerciseRecord(exerciseRecordID: self.exerciseRecordID, dateTime: self.dateTime, exercise: self.exercise.toModel(), sets: self.sets.toModels())
    }
}


public extension ExerciseRecord {
    
    func toLocal() -> LocalExerciseRecord {
        LocalExerciseRecord(exerciseRecordID: self.exerciseRecordID, dateTime: self.dateTime, exercise: self.exercise.toLocal(), sets: self.sets.toLocal())
    }
}


extension Array where Element == ExerciseRecord {
    
    public func toLocal() -> [LocalExerciseRecord] {
        
        self.map {
            LocalExerciseRecord(exerciseRecordID: $0.exerciseRecordID, dateTime: $0.dateTime, exercise: $0.exercise.toLocal(), sets: $0.sets.toLocal())
        }
    }
}


extension Array where Element == LocalExerciseRecord {
    
    func toModels() -> [ExerciseRecord] {
        self.map {
            ExerciseRecord(exerciseRecordID: $0.exerciseRecordID, dateTime: $0.dateTime, exercise: $0.exercise.toModel(), sets: $0.sets.toModels())
        }
    }
}
