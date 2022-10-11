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
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private(set) var readRoutineCompletions = [RoutineStore.ReadRoutineCompletion]()
    private(set) var createRoutineCompletions = [RoutineStore.CreateRoutineCompletion]()
    
    init() {}
    
    // Conformance to RoutineStore
    func create(_ routine: LocalRoutine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        receivedMessages.append(.createRoutine(routine))
        createRoutineCompletions.append(completion)
    }
    
    
    func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping RoutineStore.ReadRoutineCompletion) {
        
        receivedMessages.append(.readRoutines(name: name, exercises: exercises))
        readRoutineCompletions.append(completion)
    }
    
    // Spy work 🕵🏼‍♂️
    func completeReadRoutines(with routines: [LocalRoutine], at index: Int = 0) {
        readRoutineCompletions[index](.success(routines))
    }
    
    
    func completeReadRoutines(with error: NSError, at index: Int = 0) {
        readRoutineCompletions[index](.failure(error))
    }
    
    
    func completeReadRoutinesSuccessfully(at index: Int = 0) {
        completeReadRoutines(with: [], at: index)
    }
    
    
    func completeCreateRoutine(with error: NSError, at index: Int = 0) {
        createRoutineCompletions[index](.failure(error))
    }
    
    
    func completeCreateRoutineSuccessfully(at index: Int = 0) {
        createRoutineCompletions[index](.success(()))
    }
}
