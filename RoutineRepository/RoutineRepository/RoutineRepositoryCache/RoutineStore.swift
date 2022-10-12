//
//  RoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation


public protocol RoutineStore {
    
    typealias ReadRoutinesResult = Result<[LocalRoutine], Error>
    typealias CreateRoutineResult = Result<Void, Error>
    
    typealias ReadRoutinesCompletion = (ReadRoutinesResult) -> Void
    typealias CreateRoutineCompletion = (CreateRoutineResult) -> Void
    
    func create(_ routine: LocalRoutine, completion: @escaping CreateRoutineCompletion)
    // fetch routines with the given name or exercises
    func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping ReadRoutinesCompletion)
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion)
}
