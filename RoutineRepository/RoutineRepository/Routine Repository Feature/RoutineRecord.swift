//
//  RoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

struct RoutineRecord: Equatable {
    
    let id: UUID
    let creationDate: Date
    let completionDate: Date?
    
    // relationships
    let exerciseRecords: [ExerciseRecord]
}
