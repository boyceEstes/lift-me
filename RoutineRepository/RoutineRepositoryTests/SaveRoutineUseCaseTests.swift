//
//  SaveRoutineUseCaseTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/8/22.
//

import XCTest
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


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}



class SaveRoutineUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let (_, routineStore) = makeSUT()
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineNameIsAlreadyCached_deliversRoutineWithNameAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
                
        let name = "Any"
        let routine = uniqueRoutine(name: name).model
        let cachedRoutineWithSameName = uniqueRoutine(name: name).local

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithNameAlreadyExists)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameName])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(exercises: exercises).model
        let cachedRoutineWithSameExercises = uniqueRoutine(exercises: exercises)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithExercisesAlreadyExists(cachedRoutineName: cachedRoutineWithSameExercises.model.name))) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.local])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithNameAndExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let name = "Any"
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(name: name, exercises: exercises).model
        let cachedRoutineWithSameExercises = uniqueRoutine(name: name, exercises: exercises)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithNameAlreadyExists)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.local])
        }
    }
    
    
    func test_routineRepository_saveRoutineReadRoutinesWithNameAndExercisesFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: .failure(error)) {
            routineStore.completeReadRoutines(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineCreateRoutineFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: .failure(error)) {
            routineStore.completeReadRoutinesSuccessfully()
            routineStore.completeCreateRoutine(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineSucceeds_deliversSuccess() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        
        save(routine: routine, on: sut, completesWith: .success(())) {
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
            
            switch (result, expectedResult) {
            case (.success, .success): break
               
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error as NSError, expectedError as NSError, "Got \(result) but expected \(expectedResult)", file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func uniqueExercise() -> Exercise {
        return Exercise(
            id: UUID(),
            name: UUID().uuidString,
            creationDate: Date(),
            exerciseRecords: [],
            tags: [])
    }
    
    
    private func uniqueRoutine(name: String? = nil, exercises: [Exercise]? = nil) -> (model: Routine, local: LocalRoutine) {
        
        let routine = Routine(
            id: UUID(),
            name: name ?? UUID().uuidString,
            creationDate: Date(),
            exercises: exercises ?? [uniqueExercise(), uniqueExercise()],
            routineRecords: [])
        
        return (routine, routine.toLocal())
    }
    
    
    private func anyNSError() -> NSError {
        return NSError(domain: "Any", code: 0)
    }
}
