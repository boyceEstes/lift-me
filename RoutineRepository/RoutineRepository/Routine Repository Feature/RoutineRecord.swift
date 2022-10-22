//
//  RoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct RoutineRecord: Equatable, Hashable {
    
    public let id: UUID
    public let creationDate: Date
    public let completionDate: Date?
    
    // relationships
    public let exerciseRecords: [ExerciseRecord]
}
