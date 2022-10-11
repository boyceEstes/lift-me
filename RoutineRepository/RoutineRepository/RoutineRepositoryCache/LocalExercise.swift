//
//  LocalExercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalExercise: Equatable {
  
    let id: UUID
    let name: String
    let creationDate: Date
    
    // relationships
    let exerciseRecords: [LocalExerciseRecord]
    let tags: [LocalTag]
    
}
