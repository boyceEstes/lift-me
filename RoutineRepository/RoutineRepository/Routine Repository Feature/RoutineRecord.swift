//
//  RoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public struct RoutineRecord: Equatable, Hashable {
    
    public let id: UUID
    public let note: String?
    public let creationDate: Date
    public var completionDate: Date?
    
    // relationships
    public var exerciseRecords: [ExerciseRecord]
    
    
    public init(
        id: UUID,
        note: String?,
        creationDate: Date,
        completionDate: Date?,
        exerciseRecords: [ExerciseRecord]
    ) {
        
        self.id = id
        self.note = note
        self.creationDate = creationDate
        self.completionDate = completionDate
        self.exerciseRecords = exerciseRecords
    }
}
