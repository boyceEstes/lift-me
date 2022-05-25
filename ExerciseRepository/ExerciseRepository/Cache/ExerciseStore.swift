//
//  ExerciseStore.swift
//  
//
//  Created by Boyce Estes on 4/15/22.
//

import Foundation

public protocol ExerciseStore {
    
    // Exercises
    typealias RetrieveExercisesResult = Result<[LocalExercise], Error>
    
    typealias InsertExerciseCompletion = (Error?) -> Void
    typealias RetrieveAllExercisesCompletion = (RetrieveExercisesResult) -> Void
    typealias UpdateExerciseCompletion = (Error?) -> Void
    typealias DeleteExerciseCompletion = (Error?) -> Void
    
    func insert(exercise: LocalExercise, completion: @escaping InsertExerciseCompletion)
    func retrieveAll(completion: @escaping RetrieveAllExercisesCompletion)
    func update(exercise: LocalExercise, completion: @escaping UpdateExerciseCompletion)
    func delete(exercise: LocalExercise, completion: @escaping DeleteExerciseCompletion)
    

    // ExerciseRecords
    typealias RetrieveExerciseRecordsResult = Result<[LocalExerciseRecord], Error>
    
    typealias InsertExerciseRecordCompletion = (Error?) -> Void
    typealias RetrieveAllExerciseRecordsCompletion = (RetrieveExerciseRecordsResult) -> Void
    typealias DeleteExerciseRecordCompletion = (Error?) -> Void
    
    func insert(exerciseRecord: LocalExerciseRecord, completion: @escaping InsertExerciseRecordCompletion)
    func retrieveAllExerciseRecords(completion: @escaping RetrieveAllExerciseRecordsCompletion)
    func delete(exerciseRecord: LocalExerciseRecord, completion: @escaping DeleteExerciseRecordCompletion)
    
    
    // SetRecords
    typealias InsertSetRecordCompletion = (Error?) -> Void
    typealias UpdateSetRecordCompletion = (Error?) -> Void
    typealias DeleteSetRecordCompletion = (Error?) -> Void
   
    func insert(setRecord: LocalSetRecord, completion: @escaping InsertSetRecordCompletion)
    func update(setRecord: LocalSetRecord, completion: @escaping UpdateSetRecordCompletion)
    func delete(setRecord: LocalSetRecord, completion: @escaping DeleteSetRecordCompletion)
}
