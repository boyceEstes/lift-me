//
//  RoutineStoreSpy.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation
import RoutineRepository

class RoutineStoreSpy: RoutineStore {

    enum ReceivedMessage: Equatable {
        case createRoutine(LocalRoutine)
        case readRoutines(name: String, exercises: [LocalExercise])
        case readAllRoutines
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private(set) var readRoutinesCompletions = [RoutineStore.ReadRoutinesCompletion]()
    private(set) var createRoutineCompletions = [RoutineStore.CreateRoutineCompletion]()
    private(set) var readAllRoutinesCompletions = [RoutineStore.ReadRoutinesCompletion]()
    
    init() {}
    
    // Conformance to RoutineStore
    func create(_ routine: LocalRoutine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        receivedMessages.append(.createRoutine(routine))
        createRoutineCompletions.append(completion)
    }
    
    
    func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping RoutineStore.ReadRoutinesCompletion) {
        
        receivedMessages.append(.readRoutines(name: name, exercises: exercises))
        readRoutinesCompletions.append(completion)
    }
    
    
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion) {
        receivedMessages.append(.readAllRoutines)
        readAllRoutinesCompletions.append(completion)
    }
    
    // Spy work 🕵🏼‍♂️
    // Read Routines With Name and Exercises
    func completeReadRoutines(with routines: [LocalRoutine], at index: Int = 0) {
        readRoutinesCompletions[index](.success(routines))
    }
    
    
    func completeReadRoutines(with error: NSError, at index: Int = 0) {
        readRoutinesCompletions[index](.failure(error))
    }
    
    
    func completeReadRoutinesSuccessfully(at index: Int = 0) {
        completeReadRoutines(with: [], at: index)
    }
    
    
    // Create Routine
    func completeCreateRoutine(with error: NSError, at index: Int = 0) {
        createRoutineCompletions[index](.failure(error))
    }
    
    
    func completeCreateRoutineSuccessfully(at index: Int = 0) {
        createRoutineCompletions[index](.success(()))
    }
    
    
    // Read All Routines
    func completeReadAllRoutines(with error: NSError, at index: Int = 0) {
        readAllRoutinesCompletions[index](.failure(error))
    }
    
    
    func completeReadAllRoutines(with routines: [LocalRoutine], at index: Int = 0) {
        readAllRoutinesCompletions[index](.success(routines))
    }
}
