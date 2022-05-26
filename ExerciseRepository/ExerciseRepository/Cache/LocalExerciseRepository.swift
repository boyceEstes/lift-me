//
//  LocalExerciseRepository.swift
//  
//
//  Created by Boyce Estes on 4/15/22.
//

import Foundation

public class LocalExerciseRepository: ExerciseRepository {

    private let exerciseStore: ExerciseStore
    
    public init(exerciseStore: ExerciseStore) {
        self.exerciseStore = exerciseStore
    }
    
    
    // Exercises
    public func save(exercise: Exercise, completion: @escaping SaveExerciseResult) {
        
        exerciseStore.insert(exercise: exercise.toLocal()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
    
    public func update(exercise: Exercise, with updatedExercise: Exercise, completion: @escaping UpdateExerciseResult) {
        
        exerciseStore.update(exercise: exercise.toLocal(), with: updatedExercise.toLocal()) { [weak self] error in
            
            guard self != nil else { return }
            completion(error)
        }
    }

    
    public func loadAllExercises(completion: @escaping LoadAllExercisesResult) {
        exerciseStore.retrieveAll { [weak self] result in
            
            guard self != nil else { return }
            
            switch result {
            case let .success(localExercises):

                let exercises = localExercises.toModels()
                completion(.success(exercises))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    

    public func remove(exercise: Exercise, completion: @escaping RemoveExerciseResult) {
        
        exerciseStore.delete(exercise: exercise.toLocal()) { [weak self] error in
            
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
    
    // ExerciseRecords
    public func save(exerciseRecord: ExerciseRecord, completion: @escaping SaveExerciseRecordResult) {
       
        exerciseStore.insert(exerciseRecord: exerciseRecord.toLocal()) { [weak self] error in
            
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
    
    public func loadAllExerciseRecords(completion: @escaping LoadAllExerciseRecordsResult) {
        
        exerciseStore.retrieveAllExerciseRecords() { [weak self] result in
            
            guard self != nil else { return }
            
            switch result {
            case let .success(localExerciseRecords):
                completion(.success(localExerciseRecords.toModels()))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func remove(exerciseRecord: ExerciseRecord, completion: @escaping RemoveExerciseRecordResult) {
        
        exerciseStore.delete(exerciseRecord: exerciseRecord.toLocal()) { [weak self] error in
            
            guard self != nil else { return }
            completion(error)
        }
    }
    
    
    
    // SetRecords
    public func save(setRecord: SetRecord, completion: @escaping SaveSetRecordResult) {
        
        exerciseStore.insert(setRecord: setRecord.toLocal()) { error in
            completion(error)
        }
    }

    
    public func update(setRecord: SetRecord, completion: @escaping UpdateSetRecordResult) {
        
        exerciseStore.update(setRecord: setRecord.toLocal()) { [weak self] error in
            
            guard self != nil else { return }
            completion(error)
        }
    }
    
    
    public func remove(setRecord: SetRecord, completion: @escaping RemoveSetRecordResult) {
        
        exerciseStore.delete(setRecord: setRecord.toLocal()) { [weak self] error in
            
            guard self != nil else { return }
            completion(error)
        }
    }
}
