//
//  RoutineRepository.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/8/22.
//

import Foundation

public protocol RoutineRepository {
    
    typealias SaveRoutineResult = Result<Void, Error>
    typealias SaveRoutineCompletion = (RoutineRepository.SaveRoutineResult) -> Void
    
    typealias LoadAllRoutinesResult = Result<[Routine], Error>
    typealias LoadAllRoutinesCompletion = (LoadAllRoutinesResult) -> Void
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion)
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion)
}

