//
//  SetRecord.swift
//  
//
//  Created by Boyce Estes on 4/13/22.
//

import Foundation

public struct SetRecord: Equatable, Hashable {
    
    let exerciseRecord: ExerciseRecord
    let duration: Int?
    let repCount: Int?
    let weight: Int
    let difficulty: Int
    
    public init(exerciseRecord: ExerciseRecord, duration: Int?, repCount: Int?, weight: Int, difficulty: Int) {
        self.exerciseRecord = exerciseRecord
        self.duration = duration
        self.repCount = repCount
        self.weight = weight
        self.difficulty = difficulty
    }
}
