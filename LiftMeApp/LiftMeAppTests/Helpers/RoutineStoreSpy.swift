//
//  RoutineStoreSpy.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/25/23.
//

import Foundation
import RoutineRepository


class RoutineStoreSpy: RoutineStore {


    enum ReceivedMessage: Equatable {
        case saveRoutine(Routine)
        case loadAllRoutines
    }
    
    private(set) var requests = [ReceivedMessage]()
    private(set) var loadAllRoutinesCompletions = [RoutineStore.ReadRoutinesCompletion]()//[LoadAllRoutinesCompletion]()
    private(set) var saveRoutineCompletions = [RoutineStore.CreateRoutineCompletion]()//[SaveRoutineCompletion]()

    
    // MARK: - Routines
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion) {
        requests.append(.saveRoutine(routine))
        saveRoutineCompletions.append(completion)
    }
    
    
    func readRoutines(with name: String, or exercises: [Exercise], completion: @escaping ReadRoutinesCompletion) {
        // TODO: Fill in if necessary
    }
    
    
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion) {
        requests.append(.loadAllRoutines)
        loadAllRoutinesCompletions.append(completion)
    }
    
    
    func completeRoutineLoading(with error: Error, at index: Int = 0) {
        loadAllRoutinesCompletions[index](.failure(error))
    }
    
    
    func completeRoutineLoadingWithNoRoutines(at index: Int = 0) {
        loadAllRoutinesCompletions[index](.success([]))
    }
    
    
    func completeRoutineLoading(with routines: [Routine], at index: Int = 0) {
        loadAllRoutinesCompletions[index](.success(routines))
    }
    
    
    func completeSaveRoutineSuccessfully(at index: Int = 0) {
        saveRoutineCompletions[index](nil)
    }
    
    
    // MARK: - Routine Records
    func createRoutineRecord(completion: @escaping CreateRoutineRecordCompletion) {
        print("placeholder")
    }
    
    func updateRoutineRecord(newRoutineRecord: RoutineRepository.RoutineRecord, completion: @escaping UpdateRoutineRecordCompletion) {
        print("placeholder")
    }
    
    func deleteRoutineRecord(routineRecord: RoutineRepository.RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("placeholder")
    }
    
    
    // MARK: - Exercises
    func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        
    }
    
    func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        
    }
}
