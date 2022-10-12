//
//  SetRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation


public struct SetRecord: Equatable {
    
    public let id: UUID
    public let duration: Int?
    public let repCount: Int?
    public let weight: Int
    public let difficulty: Int
}
