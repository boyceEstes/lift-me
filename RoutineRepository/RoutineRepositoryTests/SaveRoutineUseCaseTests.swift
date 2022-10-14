//
//  SaveRoutineUseCaseTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/8/22.
//

import XCTest
import RoutineRepository


class SaveRoutineUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let (_, routineStore) = makeSUT()
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }
    
    
    func test_routineRepository_saveRoutineWhenReadCallFails_requestsReadAndNotCreateRoutine() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine()
        let error = anyNSError()
        
        sut.save(routine: routine.model) { _ in }
        
        routineStore.completeReadRoutines(with: error)
        
        XCTAssertEqual(
            routineStore.receivedMessages, [.readRoutines(name: routine.local.name, exercises: routine.local.exercises)]
        )
    }
    
    
    func test_routineRepository_saveRoutineWhenReadCallReturnsRoutineWithNameAlreadyExists_requestsReadAndNotCreateRoutine() {
        
        let (sut, routineStore) = makeSUT()
        
        let name = "Any"
        let routine = uniqueRoutine(name: name)
        let cachedRoutine = uniqueRoutine(name: name)
        
        sut.save(routine: routine.model) { _ in }
        
        routineStore.completeReadRoutines(with: [cachedRoutine.local])
        
        XCTAssertEqual(
            routineStore.receivedMessages, [.readRoutines(name: routine.local.name, exercises: routine.local.exercises)]
        )
    }
    
    
    func test_routineRepository_saveRoutineWhenReadCallReturnsRoutineWithExercisesAlreadyExists_requestsReadAndNotCreateRoutine() {
        
        let (sut, routineStore) = makeSUT()
        
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(exercises: exercises)
        let cachedRoutine = uniqueRoutine(exercises: exercises)
        
        sut.save(routine: routine.model) { _ in }
        
        routineStore.completeReadRoutines(with: [cachedRoutine.local])
        
        XCTAssertEqual(
            routineStore.receivedMessages, [.readRoutines(name: routine.local.name, exercises: routine.local.exercises)]
        )
    }
    
    
    func test_routineRepository_saveRoutineWhenReadReturnsNoRoutines_requestsReadAndCreateRoutine() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine()
        
        sut.save(routine: routine.model) { _ in }
        
        routineStore.completeReadRoutinesSuccessfully()
        
        XCTAssertEqual(
            routineStore.receivedMessages, [.readRoutines(name: routine.local.name, exercises: routine.local.exercises), .createRoutine(routine.local)]
        )
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineNameIsAlreadyCached_deliversRoutineWithNameAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
                
        let name = "Any"
        let routine = uniqueRoutine(name: name).model
        let cachedRoutineWithSameName = uniqueRoutine(name: name).local

        save(routine: routine, on: sut, completesWith: LocalRoutineRepository.Error.routineWithNameAlreadyExists) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameName])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(exercises: exercises).model
        let cachedRoutineWithSameExercises = uniqueRoutine(exercises: exercises)

        save(routine: routine, on: sut, completesWith: LocalRoutineRepository.Error.routineWithExercisesAlreadyExists(cachedRoutineName: cachedRoutineWithSameExercises.model.name)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.local])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithNameAndExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let name = "Any"
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(name: name, exercises: exercises).model
        let cachedRoutineWithSameExercises = uniqueRoutine(name: name, exercises: exercises)

        save(routine: routine, on: sut, completesWith: LocalRoutineRepository.Error.routineWithNameAlreadyExists) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.local])
        }
    }
    
    
    func test_routineRepository_saveRoutineReadRoutinesWithNameAndExercisesFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: error) {
            routineStore.completeReadRoutines(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineCreateRoutineFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: error) {
            routineStore.completeReadRoutinesSuccessfully()
            routineStore.completeCreateRoutine(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineSucceeds_deliversSuccess() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        
        save(routine: routine, on: sut, completesWith: nil) {
            routineStore.completeReadRoutinesSuccessfully()
            routineStore.completeCreateRoutineSuccessfully()
        }
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalRoutineRepository, routineStore: RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = LocalRoutineRepository(routineStore: routineStore)
        
        trackForMemoryLeaks(routineStore, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, routineStore)
    }
    
    
    private func save(routine: Routine, on sut: LocalRoutineRepository, completesWith expectedResult: RoutineRepository.SaveRoutineResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for save routine completion")
        
        sut.save(routine: routine) { result in
            
            XCTAssertEqual(result as NSError?, expectedResult as NSError?, file: file, line: line)

            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}
