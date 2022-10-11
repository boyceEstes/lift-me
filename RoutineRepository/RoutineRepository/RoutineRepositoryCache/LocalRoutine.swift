//
//  LocalRoutine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalRoutine: Equatable {
    
    let id: UUID
    let name: String
    let creationDate: Date
    
    // relationships
    let exercises: [LocalExercise]
    let routineRecords: [LocalRoutineRecord]
}
