//
//  LocalSetRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation

public struct LocalSetRecord: Equatable {
    
    let id: UUID
    let duration: Int?
    let repCount: Int?
    let weight: Int
    let difficulty: Int
}
