//
//  Routine.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

struct Routine {
    
    let id: UUID
    let creationDate: Date
    
    // relationships
    let exercises: [Exercise]
    let routineRecords: [RoutineRecord]
}
