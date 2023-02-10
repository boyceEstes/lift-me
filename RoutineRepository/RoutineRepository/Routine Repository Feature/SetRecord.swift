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
    public var repCount: Int?
    public var weight: Int?
    public var difficulty: Int?
    
    
    public init(id: UUID, duration: Int?, repCount: Int?, weight: Int?, difficulty: Int?) {
        
        self.id = id
        self.duration = duration
        self.repCount = repCount
        self.weight = weight
        self.difficulty = difficulty
    }
}
