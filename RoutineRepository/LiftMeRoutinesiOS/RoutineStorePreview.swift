//
//  RoutineStorePreview.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/25/23.
//

import Foundation
import RoutineRepository

class RoutineStorePreview: RoutineStore {

    func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion) {
        print("")
    }
    
    
    func updateRoutineRecord(id: UUID, updatedCompletionDate: Date?, updatedExerciseRecords: [RoutineRepository.ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion) {
        
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
    func createRoutineRecord(_ routineRecord: RoutineRepository.RoutineRecord, completion: @escaping CreateRoutineRecordCompletion) {
        print("")
    }

    
    public func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
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
            tags: [])
    }
    
    
    func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        print("")
    }
}
