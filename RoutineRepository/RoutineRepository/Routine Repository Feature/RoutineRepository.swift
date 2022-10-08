//
//  RoutineRepository.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public protocol RoutineRepository {
    
    func save(routine: Routine)
    func loadAllRoutines() -> [Routine]
}

