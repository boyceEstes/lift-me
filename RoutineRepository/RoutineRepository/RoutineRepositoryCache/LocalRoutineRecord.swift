//
//  LocalRoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalRoutineRecord: Equatable {
    
    let id: UUID
    let creationDate: Date
    let completionDate: Date?
    
    // relationships
    let exerciseRecords: [LocalExerciseRecord]
}
