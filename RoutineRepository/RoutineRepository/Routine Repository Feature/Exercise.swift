//
//  Exercise.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct Exercise {
    
    public let id: UUID
    public let creationDate: Date
    
    // relationships
    public let exerciseRecords: [ExerciseRecord]
    public let tags: [Tag]
}
