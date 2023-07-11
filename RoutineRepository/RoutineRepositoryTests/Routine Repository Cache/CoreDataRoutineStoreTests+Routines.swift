//
//  CoreDataRoutineStoreTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/11/22.
//

import XCTest
import RoutineRepository



class CoreDataRoutineStoreTests: XCTestCase {
    
    // MARK: - Read Routine
    func test_coreDataRoutineStore_readRoutinesOnEmptyCache_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expectReadAllRoutines(on: sut, toCompleteWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnEmptyCacheTwice_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expectReadAllRoutines(on: sut, toCompleteTwiceWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnNonEmtpyCache_deliversCachedRoutines() {
        
        let sut = makeSUT()
        
        // TODO: Since we have not implmented ManagedExercises, this uniqueRotuine will have to not have any for now
        let routine = uniqueRoutine(exercises: [])
        create(routine, into: sut)
        expectReadAllRoutines(on: sut, toCompleteWith: .success([routine]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnNonEmptyCacheTwice_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        // TODO: Since we have not implmented ManagedExercises, this uniqueRotuine will have to not have any for now
        let routine = uniqueRoutine(exercises: [])
        create(routine, into: sut)
        expectReadAllRoutines(on: sut, toCompleteTwiceWith: .success([routine]))
    }
    
    
    // MARK: Read Routine - for ID
    func test_coreDataRoutineStore_readRoutineWithIDOnEmptyCache_deliversCannotFindRoutineWithIDError() {

        // given
        let sut = makeSUT()

        // when/then
        let anyIDThatIsNotInRoutineStore = UUID()
        let expectedError = CoreDataRoutineStore.Error.cannotFindRoutineWithID
        
        expectReadRoutine(on: sut, with: anyIDThatIsNotInRoutineStore, toCompleteWith: .failure(expectedError))
    }
    
    
    func test_coreDataRoutineStore_readRoutineWithIDOnNonEmptyCacheWithNoMatch_deliversCannotFindRoutineWithIDError() {
        
        // given
        let sut = makeSUT()

        // when/then
        create(uniqueRoutine(), into: sut)
        
        let anyIDThatIsNotInRoutineStore = UUID()
        let expectedError = CoreDataRoutineStore.Error.cannotFindRoutineWithID
        
        expectReadRoutine(on: sut, with: anyIDThatIsNotInRoutineStore, toCompleteWith: .failure(expectedError))
    }
    
    
    // TODO: Figure out how to handle a routine with multiple matches in the db
    func test_coreDataRoutineStore_readRoutineWithIDOnNonEmptyCacheWithMultipleMatches_delivers() {}
    
    
    func test_coreDataRoutineStore_readRoutineWithIDOnNonEmptyCacheWithMatch_deliversRoutine() {
        
        // given
        let sut = makeSUT()
        let savedRoutine = uniqueRoutine()
        create(savedRoutine, into: sut)
        
        // when/then
        expectReadRoutine(on: sut, with: savedRoutine.id, toCompleteWith: .success(savedRoutine))
    }

    
    
    // MARK: - Create Routine
    func test_coreDataRoutineStore_createRoutineInEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        let routine = uniqueRoutine(exercises: [])
        let createError = create(routine, into: sut)
        XCTAssertNil(createError, "Creating routine in empty cache delivers error, \(createError!)")
    }
    
    
    func test_coreDataRoutineStore_createRoutineInEmptyCacheWithExercises_createsRoutineWithExercisesThatAreNotSavedDeliversCannotFindExerciseError() {
        
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        let routine = uniqueRoutine(exercises: [exercise])
        let createError = create(routine, into: sut)
        XCTAssertEqual(createError as? NSError, CoreDataRoutineStore.Error.cannotFindExercise as NSError)
    }
    
    
    func test_coreDataRoutineStore_createRoutineWithExercisesInCacheWithExercises_createsRoutineWithExercisesWithoutDuplicatingExercises() {
        
        // given
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        create(exercise, into: sut)
        let routine = uniqueRoutine(exercises: [exercise])
        
        // when
        let createError = create(routine, into: sut)
        
        // then
        XCTAssertNil(createError, "Creating routine in empty cache delivers error, \(createError!)")
        expectReadAllExercises(on: sut, toCompleteWith: .success([exercise]))
        expectReadAllRoutines(on: sut, toCompleteWith: .success([routine]))
    }
    
    
    func test_coreDataRoutineStore_createRoutineInNonEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        create(uniqueRoutine(exercises: []), into: sut)

        let createError = create(uniqueRoutine(exercises: []), into: sut)
        
        XCTAssertNil(createError, "Creating routine in nonempty cache delivers error, \(createError!)")
    }
    
    
    func test_coreDataRoutineStore_createUniqueRoutineWithMatchingNameInCache_deliversError() {
        
        let sut = makeSUT()
        
        let name = "same name"
        
        let routine1 = uniqueRoutine(name: name, exercises: [])
        let routine2 = uniqueRoutine(name: name, exercises: [])
        
        create(routine1, into: sut)
        let createError = create(routine2, into: sut)
        
        XCTAssertEqual(createError as? NSError, CoreDataRoutineStore.Error.routineWithNameAlreadyExists as NSError)
    }
    
    
    func test_coreDataRoutineStore_createRoutineAndRoutineRecordWithEmptyCache_createsRoutineAndAssociatedRoutineRecord() {
        
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        let setRecords = [uniqueSetRecord()]
        let exerciseRecords = [uniqueExerciseRecord(setRecords: setRecords, exercise: exercise)]
        let routineRecord = uniqueRoutineRecord(id: UUID(), creationDate: Date().adding(minutes: -60), completionDate: Date(), exerciseRecords: exerciseRecords)
        
        let routine = Routine(id: UUID(), name: "Swoler Bear Back", creationDate: Date(), exercises: [exercise], routineRecords: [routineRecord])
        
        create(exercise, into: sut)
        
        create(routine, into: sut)
//        createRoutineAndRoutineRecord(name: "Any Routine Name", routineRecord: routineRecord, into: sut)

        
        expectReadAllRoutines(on: sut, toCompleteWith: .success([routine]))
    }
    
    
    // MARK: Update Routine
    func test_coreDataRoutineStore_updateRoutineForRoutineWithEmptyCache_deliversCannotFindRoutineError() {
        
        // given
        let sut = makeSUT()
        
        // when/then
        let anyIDThatIsNotInRoutineStore = UUID()
        let updateError = update(routineID: anyIDThatIsNotInRoutineStore, with: uniqueRoutine(), in: sut)
        
        XCTAssertEqual(updateError as? NSError, CoreDataRoutineStore.Error.cannotFindRoutineWithID as NSError)
    }
    
    
    func test_coreDataRoutineStore_updateRoutineForRoutineThatExistsInNonCacheWithUpdatedRoutine_updatesRoutineWithNewValues() {
        
        // given
        let sut = makeSUT()
        
        let originalName = "Any"
        let updatedName = "Updated"
        
        let originalExercise = uniqueExercise()
        create(originalExercise, into: sut)
        
        let updatedExercise = uniqueExercise()
        create(updatedExercise, into: sut)
        
        let originalRoutine = uniqueRoutine(name: originalName, exercises: [originalExercise])
        create(originalRoutine, into: sut)
        
        let updatedRoutine = uniqueRoutine(name: updatedName, exercises: [updatedExercise])
        
        // when
        let updateError = update(routineID: originalRoutine.id, with: updatedRoutine, in: sut)
        XCTAssertNil(updateError)
        
        // then
        let expectedRoutine = Routine(id: originalRoutine.id, name: updatedRoutine.name, creationDate: originalRoutine.creationDate, exercises: updatedRoutine.exercises, routineRecords: originalRoutine.routineRecords)
        expectReadRoutine(on: sut, with: originalRoutine.id, toCompleteWith: .success(expectedRoutine))
    }
    
    
    func test_coreDataRoutineStore_updateRoutineForRoutineThatExistsInNonCacheWithUpdatedRoutine_deliversNoError() {
        
        // given
        let sut = makeSUT()
        
        let originalName = "Any"
        let updatedName = "Updated"
        
        let originalExercise = uniqueExercise()
        create(originalExercise, into: sut)
        
        let updatedExercise = uniqueExercise()
        create(updatedExercise, into: sut)
        
        let originalRoutine = uniqueRoutine(name: originalName, exercises: [originalExercise])
        create(originalRoutine, into: sut)
        
        let updatedRoutine = uniqueRoutine(name: updatedName, exercises: [updatedExercise])
        
        // when/then
        let updateError = update(routineID: originalRoutine.id, with: updatedRoutine, in: sut)
        XCTAssertNil(updateError)
    }
    
    
    // TODO: Test with matching exercises
    
    // TODO: test to make sure there is an error if there are no exercises in a routine
    
    
    // Read on Empty
    // Read on Empty twice delivers no side effects
    // Read on nonempty with matching name
    // Read on nonempty twice matching name delivers no side effects
    // Read on nonempty with matching exercises
    // Read on nonempty twice with matching exercises
    // Read on nonempty with no matching name
    // Read on nonempty twice with no matching name delivers no side effects

    
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataRoutineStore {

        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataRoutineStore(storeURL: storeURL, bundle: bundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    /*
     * This is returning a result instead of actually testing as this should be reusable
     * A command to create rather than a test to create. It should be tested as necessary
     * in the test cases
     */
    @discardableResult
    private func create(_ routine: Routine, into sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> RoutineStore.CreateRoutineResult {
        
        let exp = expectation(description: "Wait for RoutineStore create completion")
        
        var receivedResult: RoutineStore.CreateRoutineResult = nil
        
        sut.createUniqueRoutine(routine) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedResult
    }
    
    
    private func update(
        routineID: UUID,
        with newRoutine: Routine,
        in sut: CoreDataRoutineStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> RoutineStore.UpdateRoutineResult {
        
        let exp = expectation(description: "Wait for RoutineStore update completion")
        
        var receivedResult: RoutineStore.UpdateRoutineResult = nil
        
        sut.updateRoutine(with: routineID, updatedRoutine: newRoutine) { error in
            receivedResult = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedResult
    }
    
    
    private func expectReadAllExercises(on sut: CoreDataRoutineStore, toCompleteWith expectedResult: RoutineStore.ReadExercisesResult, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for RoutineStore read exercises completion")
        
        sut.readAllExercises { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(exercises), .success(expectedExercises)):
                XCTAssertEqual(exercises, expectedExercises, "Expected \(expectedExercises) but got \(exercises) instead", file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(expectedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expectReadRoutine(
        on sut: CoreDataRoutineStore,
        with id: UUID,
        toCompleteWith expectedResult: RoutineStore.ReadRoutineResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Wait for RoutineStore read routine completion")
        
        sut.readRoutine(with: id) { result in
            
            switch (result, expectedResult) {
            case let (.success(routine), .success(expectedRoutine)):
                XCTAssertEqual(routine, expectedRoutine)
                break
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error as NSError, expectedError as NSError)
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expectReadAllRoutines(on sut: CoreDataRoutineStore, toCompleteWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        
        let exp = expectation(description: "Wait for RoutineStore read completion")
        
        sut.readAllRoutines() { result in
            
            switch (result, expectedResult) {
            case let (.success(routines), .success(expectedRoutines)):
                XCTAssertEqual(routines, expectedRoutines, "---- Expected \(expectedRoutines) but got \(routines) instead", file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expectReadAllRoutines(on sut: CoreDataRoutineStore, toCompleteTwiceWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        expectReadAllRoutines(on: sut, toCompleteWith: expectedResult, file: file, line: line)
        expectReadAllRoutines(on: sut, toCompleteWith: expectedResult, file: file, line: line)
    }
    
    
//    private func expectReadAllRoutines(with name: String, or exercises: [Exercise], on sut: CoreDataRoutineStore, toCompleteWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
//
//
//        let exp = expectation(description: "Wait for RoutineStore read completion")
//
//        sut.readRoutines(with: name, or: exercises) { result in
//
//            switch (result, expectedResult) {
//            case let (.success(routines), .success(expectedRoutines)):
//                XCTAssertEqual(routines, expectedRoutines, "Expected \(expectedRoutines) but got \(routines) instead", file: file, line: line)
//
//            default:
//                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1)
//    }
    
    
//    private func expectReadAllRoutines(with name: String, or exercises: [Exercise], on sut: CoreDataRoutineStore, toCompleteTwiceWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
//
//        expectReadAllRoutines(with: name, or: exercises, on: sut, toCompleteWith: expectedResult, file: file, line: line)
//        expectReadAllRoutines(with: name, or: exercises, on: sut, toCompleteWith: expectedResult, file: file, line: line)
//    }
}

