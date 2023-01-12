//
//  RoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation


public protocol RoutineStore {
    
    // Result Types
    typealias ReadRoutinesResult = Result<[Routine], Error>
    typealias CreateRoutineResult = Error?
    
    typealias CreateRoutineRecordResult = Result<RoutineRecord, Error>
    typealias UpdateRoutineRecordResult = Error?
    typealias DeleteRoutineRecordResult = Error?
    
    typealias ReadExercisesResult = Result<[Exercise], Error>
    
    
    // Completion Types
    typealias ReadRoutinesCompletion = (ReadRoutinesResult) -> Void
    typealias CreateRoutineCompletion = (CreateRoutineResult) -> Void
    
    typealias CreateRoutineRecordCompletion = (CreateRoutineRecordResult) -> Void
    typealias UpdateRoutineRecordCompletion = (UpdateRoutineRecordResult) -> Void
    typealias DeleteRoutineRecordCompletion = (DeleteRoutineRecordResult) -> Void
    
    typealias ReadExercisesCompletion = (ReadExercisesResult) -> Void
    
    
    // Public methods
    // These are not guaranteed to be returned on the main thread so the client will need to make sure
    // they have accounted for that
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion)
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion)
    
    func createRoutineRecord(completion: @escaping CreateRoutineRecordCompletion)
    // Assuming that the ID will be the same as a currently existing routine record
    func updateRoutineRecord(newRoutineRecord: RoutineRecord, completion: @escaping UpdateRoutineRecordCompletion)
    func deleteRoutineRecord(routineRecord: RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion)
    
    func readAllExercises(completion: @escaping ReadExercisesCompletion)
}
