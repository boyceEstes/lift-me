//
//  SetRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation


public struct SetRecord: Equatable, Hashable {
    
    public let id: UUID
    public var duration: Int?
    public var repCount: Double
    public var weight: Double
    public var difficulty: Int?
    public let completionDate: Date
    
    
    public init(
        id: UUID,
        duration: Int?,
        repCount: Double,
        weight: Double,
        difficulty: Int?,
        completionDate: Date
    ) {
        
        self.id = id
        self.duration = duration
        self.repCount = repCount
        self.weight = weight
        self.difficulty = difficulty
        self.completionDate = completionDate
    }
    
    
    var oneRepMax: Double? {
        ORMCalculationPolicy.calculateORM(reps: repCount, weight: weight)
    }
}
