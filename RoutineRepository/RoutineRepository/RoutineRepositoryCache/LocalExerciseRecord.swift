//
//  LocalExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalExerciseRecord: Equatable {
    
    let id: UUID
    
    // relationships
    let setRecords: [LocalSetRecord]
}
