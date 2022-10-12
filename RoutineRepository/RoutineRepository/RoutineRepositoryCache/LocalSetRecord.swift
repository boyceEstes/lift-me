//
//  LocalSetRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalSetRecord: Equatable {
    
    public let id: UUID
    public let duration: Int?
    public let repCount: Int?
    public let weight: Int
    public let difficulty: Int
    
    
    public init(id: UUID, duration: Int?, repCount: Int?, weight: Int, difficulty: Int) {
        self.id = id
        self.duration = duration
        self.repCount = repCount
        self.weight = weight
        self.difficulty = difficulty
    }
}
