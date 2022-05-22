//
//  FeedStoreSpy.swift
//  
//
//  Created by Boyce Estes on 4/15/22.
//

import LiftMeExercises


class ExerciseStoreSpy: ExerciseStore {
    
    enum ReceivedMessage: Equatable {
        case insert(exercise: LocalExercise)
        case insert(exerciseRecord: LocalExerciseRecord)
        case insert(setRecord: LocalSetRecord)
        case retrieveAll
        case retrieveAllExerciseRecords
        case update(exercise: LocalExercise)
        case update(setRecord: LocalSetRecord)
        case delete(exercise: LocalExercise)
        case delete(exerciseRecord: LocalExerciseRecord)
        case delete(setRecord: LocalSetRecord)
    }

    var receivedMessages = [ReceivedMessage]()
    
    var insertExerciseCompletions = [InsertExerciseCompletion]()
    var insertExerciseRecordCompletions = [InsertExerciseRecordCompletion]()
    var insertSetRecordCompletions = [InsertSetRecordCompletion]()
    
    var updateExerciseCompletions = [UpdateExerciseCompletion]()
    var updateSetRecordCompletions = [UpdateSetRecordCompletion]()
    
    var retrieveAllExercisesCompletions = [RetrieveAllExercisesCompletion]()
    var retrieveAllExerciseRecordsCompletions = [RetrieveAllExerciseRecordsCompletion]()
    
    var deleteExerciseCompletions = [DeleteExerciseCompletion]()
    var deleteExerciseRecordCompletions = [DeleteExerciseRecordCompletion]()
    var deleteSetRecordCompletions = [DeleteSetRecordCompletion]()
    
    
    func insert(exercise: LocalExercise, completion: @escaping (Error?) -> Void) {
        
        receivedMessages.append(.insert(exercise: exercise))
        insertExerciseCompletions.append(completion)
    }
    
    
    func insert(exerciseRecord: LocalExerciseRecord, completion: @escaping InsertExerciseRecordCompletion) {
        
        receivedMessages.append(.insert(exerciseRecord: exerciseRecord))
        insertExerciseRecordCompletions.append(completion)
    }
    
    
    func insert(setRecord: LocalSetRecord, completion: @escaping InsertSetRecordCompletion) {
        
        receivedMessages.append(.insert(setRecord: setRecord))
        insertSetRecordCompletions.append(completion)
    }
    
    
    func update(exercise: LocalExercise, completion: @escaping UpdateExerciseCompletion) {
        
        receivedMessages.append(.update(exercise: exercise))
        updateExerciseCompletions.append(completion)
    }
    
    
    func update(setRecord: LocalSetRecord, completion: @escaping UpdateSetRecordCompletion) {
        
        receivedMessages.append(.update(setRecord: setRecord))
        updateSetRecordCompletions.append(completion)
    }
    
    
    func retrieveAll(completion: @escaping RetrieveAllExercisesCompletion) {
        
        receivedMessages.append(.retrieveAll)
        retrieveAllExercisesCompletions.append(completion)
    }
    
    
    func retrieveAllExerciseRecords(completion: @escaping RetrieveAllExerciseRecordsCompletion) {
        
        receivedMessages.append(.retrieveAllExerciseRecords)
        retrieveAllExerciseRecordsCompletions.append(completion)
    }
    
    
    func delete(exercise: LocalExercise, completion: @escaping DeleteExerciseCompletion) {
        
        receivedMessages.append(.delete(exercise: exercise))
        deleteExerciseCompletions.append(completion)
    }
    
    
    func delete(exerciseRecord: LocalExerciseRecord, completion: @escaping DeleteExerciseRecordCompletion) {
        
        receivedMessages.append(.delete(exerciseRecord: exerciseRecord))
        deleteExerciseRecordCompletions.append(completion)
    }
    
    
    func delete(setRecord: LocalSetRecord, completion: @escaping DeleteSetRecordCompletion) {
        
        receivedMessages.append(.delete(setRecord: setRecord))
        deleteSetRecordCompletions.append(completion)
    }
    
    
    // MARK: - Complete with's
    // Insert Exercise
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertExerciseCompletions[index](error)
    }
    
    
    func completeInsertion(at index: Int = 0) {
        insertExerciseCompletions[index](nil)
    }
    
    
    // Insert Exercise Record
    func completeExerciseRecordInsertion(with error: Error, at index: Int = 0) {
        insertExerciseRecordCompletions[index](error)
    }
    
    
    func completeExerciseRecordInsertion(at index: Int = 0) {
        insertExerciseRecordCompletions[index](nil)
    }
    
    
    // Insert Set Record
    func completeInsertSetRecord(with error: Error, index: Int = 0) {
        
        insertSetRecordCompletions[index](error)
    }
    
    
    func completeInsertSetRecord(index: Int = 0) {
        
        insertSetRecordCompletions[index](nil)
    }
    
    
    // Update Exercise
    func completeUpdateExercise(with error: Error, index: Int = 0) {
        
        updateExerciseCompletions[index](error)
    }
    
    
    func completeUpdateExercise(index: Int = 0) {
        
        updateExerciseCompletions[index](nil)
    }
    
    
    // Update Set Record
    func completeUpdateSetRecord(with error: Error, index: Int = 0) {
        
        updateSetRecordCompletions[index](error)
    }
    
    
    func completeUpdateSetRecord(index: Int = 0) {
        
        updateSetRecordCompletions[index](nil)
    }
    
    
    // Retrieve All Exercises
    func completeRetrieveAll(with error: Error, at index: Int = 0) {
        retrieveAllExercisesCompletions[index](.failure(error))
    }
    
    
    func completeRetrieveAllWithEmptyCache(at index: Int = 0) {
        retrieveAllExercisesCompletions[index](.success([]))
    }
    
    
    func completeRetrieveAll(with exercises: [LocalExercise], at index: Int = 0) {
        retrieveAllExercisesCompletions[index](.success(exercises))
    }

    
    // Retrieve All Exercise Records
    func completeRetrieveAllExerciseRecords(with error: Error, at index: Int = 0) {
        retrieveAllExerciseRecordsCompletions[index](.failure(error))
    }
    
    
    func completeRetrieveAllExerciseRecordsWithEmptyCache(at index: Int = 0) {
        
        retrieveAllExerciseRecordsCompletions[index](.success([]))
    }
    
    
    func completeRetrieveAllExerciseRecords(with exerciseRecords: [LocalExerciseRecord], index: Int = 0) {
        
        retrieveAllExerciseRecordsCompletions[index](.success(exerciseRecords))
    }
    
    
    // Delete Exercise
    func completeDeleteExercise(with error: Error, index: Int = 0) {
        
        deleteExerciseCompletions[index](error)
    }
    
    
    func completeDeleteExercise(index: Int = 0) {
        
        deleteExerciseCompletions[index](nil)
    }
    
    
    // Delete Exercise Record
    func completeDeleteExerciseRecord(with error: Error, at index: Int = 0) {
        
        deleteExerciseRecordCompletions[index](error)
    }
    
    
    func completeDeleteExerciseRecord(at index: Int = 0) {
        
        deleteExerciseRecordCompletions[index](nil)
    }
    
    
    func completeDeleteSetRecord(with error: Error, at index: Int = 0) {
        
        deleteSetRecordCompletions[index](error)
    }
    
    
    func completeDeleteSetRecord(at index: Int = 0) {
        
        deleteSetRecordCompletions[index](nil)
    }

}
