//
//  LocalExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalExerciseRecord: Equatable {
    
    public let id: UUID
    
    // relationships
    public let setRecords: [LocalSetRecord]
    
    public init(id: UUID, setRecords: [LocalSetRecord]) {
        self.id = id
        self.setRecords = setRecords
    }
}
