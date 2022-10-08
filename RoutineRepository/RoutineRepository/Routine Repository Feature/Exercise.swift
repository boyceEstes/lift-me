//
//  Exercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

struct Exercise: Equatable {
    
    let id: UUID
    let creationDate: Date
    
    // relationships
    let exerciseRecord: [ExerciseRecord]
    let tags: [Tag]
}
