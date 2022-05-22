//
//  LocalSetRecord.swift
//  
//
//  Created by Boyce Estes on 4/20/22.
//

import Foundation

public struct LocalSetRecord: Equatable, Codable {
    
    let exerciseRecord: LocalExerciseRecord
    let duration: Int?
    let repCount: Int?
    let weight: Int
    let difficulty: Int
}


public extension SetRecord {
    
    func toLocal() -> LocalSetRecord {
        LocalSetRecord(exerciseRecord: self.exerciseRecord.toLocal(), duration: self.duration, repCount: self.repCount, weight: self.weight, difficulty: self.difficulty)
    }
}


extension Array where Element == SetRecord {
    
    func toLocal() -> [LocalSetRecord] {
        
        self.map {
            LocalSetRecord(exerciseRecord: $0.exerciseRecord.toLocal(), duration: $0.duration, repCount: $0.repCount, weight: $0.weight, difficulty: $0.difficulty)
        }
    }
}

extension Array where Element == LocalSetRecord {
    
    func toModels() -> [SetRecord] {
        self.map {
            SetRecord(exerciseRecord: $0.exerciseRecord.toModel(), duration: $0.duration, repCount: $0.repCount, weight: $0.weight, difficulty: $0.difficulty)
        }
    }
}
