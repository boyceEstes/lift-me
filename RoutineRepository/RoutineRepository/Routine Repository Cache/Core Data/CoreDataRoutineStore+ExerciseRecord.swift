//
//  CoreDataRoutineStore+ExerciseRecord.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation

extension CoreDataRoutineStore {
    
    public func readExerciseRecords(for exercise: Exercise, completion: @escaping ReadExerciseRecordsCompletion) {
        
        completion(.success([]))
    }
}
