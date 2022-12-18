//
//  RoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation


public protocol RoutineStore {
    
    typealias ReadRoutinesResult = Result<[Routine], Error>
    typealias CreateRoutineResult = Error?
    
    typealias ReadRoutinesCompletion = (ReadRoutinesResult) -> Void
    typealias CreateRoutineCompletion = (CreateRoutineResult) -> Void
    
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion)
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion)
}
