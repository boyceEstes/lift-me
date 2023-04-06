//
//  RoutineStorePreview.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/25/23.
//

import Foundation
import RoutineRepository
import Combine

// TODO: Figure out a way to make the RootView unnecessary so that we can keep this internal for the LiftMeiOS
class RoutineDataSourcePreview: RoutineDataSource {
    var routines = CurrentValueSubject<[RoutineRepository.Routine], Error>([]).eraseToAnyPublisher()
}

public class RoutineStorePreview: RoutineStore {
    
    public func readExerciseRecords(for exercise: RoutineRepository.Exercise, completion: @escaping ReadExerciseRecordsCompletion) {
        print("")
    }
    

    public func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion) {
        print("")
    }
    
    
    public func updateRoutineRecord(id: UUID, updatedCompletionDate: Date?, updatedExerciseRecords: [RoutineRepository.ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion) {
        
        print("")
    }
    

    // MARK: - Routines
    public func createUniqueRoutine(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        completion(nil)
    }
    
    
    public func routineDataSource() -> RoutineDataSource {
        return RoutineDataSourcePreview()
    }
    
    
    public func readAllRoutines(completion: @escaping ReadRoutinesCompletion) {
        
        let routine = Routine(
            id: UUID(),
            name: "Preview",
            creationDate: Date(),
            exercises: [],
            routineRecords: [])
        completion(.success([routine]))
    }

    
    // MARK: - Routine Records
    public func createRoutineRecord(_ routineRecord: RoutineRepository.RoutineRecord, routine: Routine? = nil, completion: @escaping CreateRoutineRecordCompletion) {
        print("")
    }

    
    public func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
        print("")
    }
    
    
    public func deleteRoutineRecord(routineRecord: RoutineRepository.RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("")
    }
    
    
    // MARK: - Exercises
    public func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        
        let exercise = Exercise(
            id: UUID(),
            name: "Dumbbell Press",
            creationDate: Date(),
            tags: [])
    }
    
    
    public func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        print("")
    }
}
