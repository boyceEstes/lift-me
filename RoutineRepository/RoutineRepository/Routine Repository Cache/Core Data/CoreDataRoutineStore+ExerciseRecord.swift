//
//  CoreDataRoutineStore+ExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation

extension CoreDataRoutineStore {
    
    public func readExerciseRecords(for exercise: Exercise, completion: @escaping ReadExerciseRecordsCompletion) {
        
        let context = context
        context.perform {
            do {
                let exerciseRecords = try ManagedExercise.findExerciseRecords(for: exercise, in: context)
                completion(.success(exerciseRecords.toModel()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
