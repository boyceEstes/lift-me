//
//  ExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct ExerciseRecord: Equatable {
    
    public let id: UUID
    
    // relationships
    public let setRecords: [SetRecord]
}
