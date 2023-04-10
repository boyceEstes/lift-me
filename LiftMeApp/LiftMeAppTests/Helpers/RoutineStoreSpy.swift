//
//  RoutineStoreSpy.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/25/23.
//

import Foundation
import Combine
import RoutineRepository


class RoutineDataSourceSpy: RoutineDataSource {
    
    var routinesSubject = CurrentValueSubject<[Routine], Error>([])
    var routines: AnyPublisher<[Routine], Error> {
        routinesSubject.eraseToAnyPublisher()
    }
}



class RoutineStoreSpy: RoutineStore {

    enum ReceivedMessage: Equatable {
        case saveRoutine(Routine)
        case createRoutineRecord
        case readAllRoutineRecords
        case createExercise(Exercise)
        case readAllExercises
        case readAllExerciseRecords(Exercise)
    }
    
    private(set) var requests = [ReceivedMessage]()

    
    // MARK: - Routines
    
    let routineDataSourceSpy = RoutineDataSourceSpy()
    private(set) var saveRoutineCompletions = [RoutineStore.CreateRoutineCompletion]()
    
    
    func createUniqueRoutine(_ routine: Routine, completion: @escaping CreateRoutineCompletion) {
        requests.append(.saveRoutine(routine))
        saveRoutineCompletions.append(completion)
    }


    func routineDataSource() -> RoutineRepository.RoutineDataSource {
        
        print("BOYCE: Request routineDataSource")
        return routineDataSourceSpy
    }
    
    
    func completeRoutineLoading(with error: Error, at index: Int = 0) {
//        loadAllRoutinesCompletions[index](.failure(error))
        print("BOYCE: completing with error")
        routineDataSourceSpy.routinesSubject.send(completion: .failure(error))
    }
    
    
    func completeRoutineLoadingWithNoRoutines(at index: Int = 0) {
//        loadAllRoutinesCompletions[index](.success([]))
        print("BOYCE: completing with no routines")
        routineDataSourceSpy.routinesSubject.send([])
    }
    
    
    func completeRoutineLoading(with routines: [Routine], at index: Int = 0) {
//        loadAllRoutinesCompletions[index](.success(routines))
        self.routineDataSourceSpy.routinesSubject.send(routines)
    }
    
    
    func completeSaveRoutineSuccessfully(at index: Int = 0) {
        saveRoutineCompletions[index](nil)
    }
    
    
    // MARK: - Routine Records
    
    private(set) var readAllRoutineRecordsCompletions = [RoutineStore.ReadAllRoutineRecordsCompletion]()
    
    
    func createRoutineRecord(_ routineRecord: RoutineRepository.RoutineRecord, routine: RoutineRepository.Routine?, completion: @escaping CreateRoutineRecordCompletion) {
        // TODO: Test for saving a routine record AND a routine
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
    private (set) var createExerciseCompletions = [RoutineStore.CreateExerciseCompletion]()
    
    
    func readAllExercises(completion: @escaping ReadExercisesCompletion) {
        
        requests.append(.readAllExercises)
        readAllExercisesCompletions.append(completion)
    }
    
    
    func createExercise(_ exercise: RoutineRepository.Exercise, completion: @escaping CreateExerciseCompletion) {
        
        requests.append(.createExercise(exercise))
        createExerciseCompletions.append(completion)
    }
    
    
    func completeReadAllExercises(with exercises: [Exercise], at index: Int = 0) {
        readAllExercisesCompletions[index](.success(exercises))
    }
    
    
    func completeCreateExercise(error: Error?, at index: Int = 0) {
        
        createExerciseCompletions[index](error)
    }
    
    
    // MARK: - Exercise Records
    
    private(set) var readExerciseRecordsCompletions = [RoutineStore.ReadExerciseRecordsCompletion]()
    
    func readExerciseRecords(for exercise: RoutineRepository.Exercise, completion: @escaping ReadExerciseRecordsCompletion) {
        requests.append(.readAllExerciseRecords(exercise))
        readExerciseRecordsCompletions.append(completion)
    }
    
    
    func completeReadExerciseRecordsForExercise(with exerciseRecords: [ExerciseRecord], at index: Int = 0) {
        readExerciseRecordsCompletions[index](.success(exerciseRecords))
    }
}
