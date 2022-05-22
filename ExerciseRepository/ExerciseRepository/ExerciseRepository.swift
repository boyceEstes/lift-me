//
//  ExerciseRepository.swift
//  
//
//  Created by Boyce Estes on 4/13/22.
//

import Foundation

public protocol ExerciseRepository {
    
    // Exercises
    typealias ExerciseResult = Result<[Exercise], Error>
    typealias SaveExerciseResult = (Error?) -> Void
    typealias UpdateExerciseResult = (Error?) -> Void
    typealias LoadAllExercisesResult = (ExerciseResult) -> Void
    typealias RemoveExerciseResult = (Error?) -> Void
    
    // ExerciseRecords
    typealias SaveExerciseRecordResult = (Error?) -> Void
    typealias LoadAllExerciseRecordsResult = (Result<[ExerciseRecord], Error>) -> Void
    typealias RemoveExerciseRecordResult = (Error?) -> Void

    // SetRecords
    typealias SaveSetRecordResult = (Error?) -> Void
    typealias UpdateSetRecordResult = (Error?) -> Void
    typealias RemoveSetRecordResult = (Error?) -> Void
    
    
    // Exercises
    func save(exercise: Exercise, completion: @escaping SaveExerciseResult)
    func update(exercise: Exercise, completion: @escaping UpdateExerciseResult)
    func loadAllExercises(completion: @escaping LoadAllExercisesResult)
    func remove(exercise: Exercise, completion: @escaping RemoveExerciseResult)
    
    // ExerciseRecords
    func save(exerciseRecord: ExerciseRecord, completion: @escaping SaveExerciseRecordResult)
    func loadAllExerciseRecords(completion: @escaping LoadAllExerciseRecordsResult)
    func remove(exerciseRecord: ExerciseRecord, completion: @escaping RemoveExerciseRecordResult)
    
    // SetRecords
    func save(setRecord: SetRecord, completion: @escaping SaveSetRecordResult)
    func update(setRecord: SetRecord, completion: @escaping UpdateSetRecordResult)
    func remove(setRecord: SetRecord, completion: @escaping RemoveSetRecordResult)
}
