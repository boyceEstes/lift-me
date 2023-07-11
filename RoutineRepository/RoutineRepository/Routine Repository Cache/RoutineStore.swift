//
//  RoutineStore.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation


public protocol RoutineStore {
    
    // Result Types
    typealias ReadRoutineResult = Result<Routine, Error>
    typealias ReadRoutinesResult = Result<[Routine], Error>
    typealias CreateRoutineResult = Error?
    
    typealias CreateRoutineRecordResult = Error?
    typealias ReadRoutineRecordResult = Result<RoutineRecord, Error>
    typealias ReadAllRoutineRecordsResult = Result<[RoutineRecord], Error>
    typealias UpdateRoutineRecordResult = Error?
    typealias DeleteRoutineRecordResult = Error?
    
    typealias ReadExercisesResult = Result<[Exercise], Error>
    typealias CreateExerciseResult = Error?
    typealias DeleteExerciseResult = Error?
    
    typealias ReadExerciseRecordsResult = Result<[ExerciseRecord], Error>
    
    
    // Completion Types
    typealias ReadRoutineCompletion = (ReadRoutineResult) -> Void
    typealias ReadRoutinesCompletion = (ReadRoutinesResult) -> Void
    typealias CreateRoutineCompletion = (CreateRoutineResult) -> Void
    
    
    typealias CreateRoutineRecordCompletion = (CreateRoutineRecordResult) -> Void
    typealias ReadRoutineRecordCompletion = (ReadRoutineRecordResult) -> Void
    typealias ReadAllRoutineRecordsCompletion = (ReadAllRoutineRecordsResult) -> Void
    typealias UpdateRoutineRecordCompletion = (UpdateRoutineRecordResult) -> Void
    typealias DeleteRoutineRecordCompletion = (DeleteRoutineRecordResult) -> Void
    
    
    typealias CreateExerciseCompletion = (CreateExerciseResult) -> Void
    typealias ReadExercisesCompletion = (ReadExercisesResult) -> Void
    typealias DeleteExerciseCompletion = (DeleteExerciseResult) -> Void
    
    typealias ReadExerciseRecordsCompletion = (ReadExerciseRecordsResult) -> Void

    
    // These are not guaranteed to be returned on the main thread so the client will need to make sure
    // they have accounted for that
    
    // Public methods
    
    // Routines
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion)
//    func readAllRoutines(completion: @escaping ReadRoutinesCompletion)
    func routineDataSource() -> RoutineDataSource
    func readRoutine(with id: UUID, completion: @escaping ReadRoutineCompletion)
    
    // Routine Records
    func createRoutineRecord(_ routineRecord: RoutineRecord, routine: Routine?, completion: @escaping CreateRoutineRecordCompletion)
    func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion)
//    func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion)
    func updateRoutineRecord(id: UUID, updatedCompletionDate: Date?, updatedExerciseRecords: [ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion)
    // Assuming that the ID will be the same as a currently existing routine record
    func deleteRoutineRecord(routineRecord: RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion)
    
    // Exercises
    func readAllExercises(completion: @escaping ReadExercisesCompletion)
    func createExercise(_ exercise: Exercise, completion: @escaping CreateExerciseCompletion)
    func deleteExercise(by exerciseID: UUID, completion: @escaping DeleteExerciseCompletion)
    func exerciseDataSource() -> ExerciseDataSource
    
    // ExerciseRecords
    func readExerciseRecords(for exercise: Exercise, completion: @escaping ReadExerciseRecordsCompletion)
    
}
