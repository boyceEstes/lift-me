//
//  LocalRoutineRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalRoutineRecord: Equatable {

    public let id: UUID
    public let creationDate: Date
    public let completionDate: Date?
    
    // relationships
    public let exerciseRecords: [LocalExerciseRecord]
    
    public init(id: UUID, creationDate: Date, completionDate: Date?, exerciseRecords: [LocalExerciseRecord]) {
        self.id = id
        self.creationDate = creationDate
        self.completionDate = completionDate
        self.exerciseRecords = exerciseRecords
    }
}
