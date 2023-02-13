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
        case createRoutineRecord
        case readAllRoutineRecords
        case readAllExercises
    }
    
    private(set) var requests = [ReceivedMessage]()

    
    // MARK: - Routines
    
    private(set) var loadAllRoutinesCompletions = [RoutineStore.ReadRoutinesCompletion]()
    private(set) var saveRoutineCompletions = [RoutineStore.CreateRoutineCompletion]()
    
    
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion) {
        requests.append(.saveRoutine(routine))
        saveRoutineCompletions.append(completion)
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
    
    private(set) var readAllRoutineRecordsCompletions = [RoutineStore.ReadAllRoutineRecordsCompletion]()
    
    func createRoutineRecord(_ routineRecord: RoutineRepository.RoutineRecord, completion: @escaping CreateRoutineRecordCompletion) {
        requests.append(.createRoutineRecord)
    }
    
    
    func readRoutineRecord(with id: UUID, completion: @escaping ReadRoutineRecordCompletion) {
        print("placeholder")
    }
    
    
    func readAllRoutineRecords(completion: @escaping ReadAllRoutineRecordsCompletion) {
        requests.append(.readAllRoutineRecords)
        readAllRoutineRecordsCompletions.append(completion)
    }
    
    
    func updateRoutineRecord(id: UUID, updatedCompletionDate: Date?, updatedExerciseRecords: [RoutineRepository.ExerciseRecord], completion: @escaping UpdateRoutineRecordCompletion) {
        
        print("placeholder")
    }
    
    
    func deleteRoutineRecord(routineRecord: RoutineRepository.RoutineRecord, completion: @escaping DeleteRoutineRecordCompletion) {
        print("placeholder")
    }
    
    
    // Completions
    func completeReadRoutineRecords(with routineRecords: [RoutineRecord], at index: Int = 0) {
        readAllRoutineRecordsCompletions[index](.success(routineRecords))
    }
    
    
    // MARK: - Exercises
    
    private(set) var readAllExercisesCompletions = [RoutineStore.ReadExercisesCompletion]()
    
    
    func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        
        requests.append(.readAllExercises)
        readAllExercisesCompletions.append(completion)
    }
    
    
    func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        
    }
    
    
    func completeReadAllExercises(with exercises: [Exercise], at index: Int = 0) {
        readAllExercisesCompletions[index](.success(exercises))
    }
}
