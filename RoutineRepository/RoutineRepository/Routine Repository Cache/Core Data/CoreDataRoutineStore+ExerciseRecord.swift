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
                let orderedExerciseRecords = ExerciseRecordDisplayOrderPolicy.sortByDate(exerciseRecords.toModel())
                completion(.success(orderedExerciseRecords))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
