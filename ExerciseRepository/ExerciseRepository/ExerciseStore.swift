//
//  ExerciseStore.swift
//  
//
//  Created by Boyce Estes on 4/15/22.
//

import Foundation

public protocol ExerciseStore {
    
    typealias InsertExerciseCompletion = (Error?) -> Void
    typealias InsertExerciseRecordCompletion = (Error?) -> Void
    typealias InsertSetRecordCompletion = (Error?) -> Void
    
    typealias UpdateExerciseCompletion = (Error?) -> Void
    typealias UpdateSetRecordCompletion = (Error?) -> Void
    
    typealias RetrieveAllExercisesCompletion = (Result<[LocalExercise], Error>) -> Void
    typealias RetrieveAllExerciseRecordsCompletion = (Result<[LocalExerciseRecord], Error>) -> Void
    
    typealias DeleteExerciseCompletion = (Error?) -> Void
    typealias DeleteExerciseRecordCompletion = (Error?) -> Void
    typealias DeleteSetRecordCompletion = (Error?) -> Void
    
    
    func insert(exercise: LocalExercise, completion: @escaping InsertExerciseCompletion)
    func insert(exerciseRecord: LocalExerciseRecord, completion: @escaping InsertExerciseRecordCompletion)
    func insert(setRecord: LocalSetRecord, completion: @escaping InsertSetRecordCompletion)
    
    
    func update(exercise: LocalExercise, completion: @escaping UpdateExerciseCompletion)
    func update(setRecord: LocalSetRecord, completion: @escaping UpdateSetRecordCompletion)
    
    
    func retrieveAll(completion: @escaping RetrieveAllExercisesCompletion)
    func retrieveAllExerciseRecords(completion: @escaping RetrieveAllExerciseRecordsCompletion)
    
    
    func delete(exercise: LocalExercise, completion: @escaping DeleteExerciseCompletion)
    func delete(exerciseRecord: LocalExerciseRecord, completion: @escaping DeleteExerciseRecordCompletion)
    func delete(setRecord: LocalSetRecord, completion: @escaping DeleteSetRecordCompletion)
}
