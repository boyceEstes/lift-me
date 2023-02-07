//
//  RoutineStorePreview.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/25/23.
//

import Foundation
import RoutineRepository

class RoutineStorePreview: RoutineStore {
    func getIncompleteRoutineRecord(creationDate: () -> Date, completion: @escaping GetIncompleteRoutineRecordCompletion) {
        print("")
    }
    

    // MARK: - Routines
    func createUniqueRoutine(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        completion(nil)
    }
    
    
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion) {
        
        let routine = Routine(
            id: UUID(),
            name: "Preview",
            creationDate: Date(),
            exercises: [],
            routineRecords: [])
        completion(.success([routine]))
    }

    
    // MARK: - Routine Records
    func createRoutineRecord(completion: @escaping CreateRoutineRecordCompletion) {
        print("")
    }
    
    
    public func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
        print("")
    }
    
    
    func updateRoutineRecord(with id: UUID, newRoutineRecord: RoutineRepository.RoutineRecord, completion: @escaping UpdateRoutineRecordCompletion) {
        print("")
    }
    
    
    func deleteRoutineRecord(routineRecord: RoutineRepository.RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("")
    }
    
    
    // MARK: - Exercises
    func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        
        let exercise = Exercise(
            id: UUID(),
            name: "Dumbbell Press",
            creationDate: Date(),
            exerciseRecords: [],
            tags: [])
    }
    
    
    func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        print("")
    }
}
