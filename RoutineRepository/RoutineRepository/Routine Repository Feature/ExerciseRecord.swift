//
//  ExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

struct ExerciseRecord {
    
    let id: UUID
    
    // relationships
    let setRecords: [SetRecord]
}
