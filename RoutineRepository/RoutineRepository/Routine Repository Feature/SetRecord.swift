//
//  SetRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation


struct SetRecord: Equatable {
    
    let id: UUID
    let duration: Int?
    let repCount: Int?
    let weight: Int
    let difficulty: Int
}
