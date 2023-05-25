//
//  CoreDataRoutineStoreTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/11/22.
//

import XCTest
import RoutineRepository



class CoreDataRoutineStoreTests: XCTestCase {
    
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
    
    
    func test_coreDataRoutineStore_createRoutineInEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        let routine = uniqueRoutine(exercises: [])
        let createError = create(routine, into: sut)
        XCTAssertNil(createError, "Creating routine in empty cache delivers error, \(createError!)")
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
    
    
    // TODO: Test with matching exercises
    
    // TODO: test to make sure there is an error if there are no exercises in a routine
    
    
    
    // TODO: Decide if I should delete all of this or if it is safer to test its functionality with our already-made tests
    // Read on Empty
    // Read on Empty twice delivers no side effects
    // Read on nonempty with matching name
    // Read on nonempty twice matching name delivers no side effects
    // Read on nonempty with matching exercises
    // Read on nonempty twice with matching exercises
    // Read on nonempty with no matching name
    // Read on nonempty twice with no matching name delivers no side effects
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesOnEmptyCache_deliversNoResults() {
//
//        let sut = makeSUT()
//
//        expectReadAllRoutines(with: "AnyName", or: [], on: sut, toCompleteWith: .success([]))
//    }
//
//
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesTwiceOnEmptyCache_deliversNoResults() {
//
//        let sut = makeSUT()
//
//        expectReadAllRoutines(with: "AnyName", or: [], on: sut, toCompleteTwiceWith: .success([]))
//    }
//
//
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesWithSameNamedRoutineInCache_deliversDuplicateNameRoutine() {
//
//        let sut = makeSUT()
//
//        let name = "AnyName"
//        let routine = uniqueRoutine(name: name, exercises: [])
//        create(routine, into: sut)
//
//        expectReadAllRoutines(with: name, or: [], on: sut, toCompleteWith: .success([routine]))
//    }
//
//
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesTwiceWithSameNamedRoutineInCache_deliversNoSideEffects() {
//        let sut = makeSUT()
//
//        let name = "AnyName"
//        let routine = uniqueRoutine(name: name, exercises: [])
//        create(routine, into: sut)
//
//        expectReadAllRoutines(with: name, or: [], on: sut, toCompleteTwiceWith: .success([routine]))
//    }
    
    
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesWithSameExercisesRoutineInCache_deliversDuplicateExercisesRoutine() {}
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesTwiceWithSameExercisesRoutineInCache_deliversDuplicateExercisesRoutine() {}
    
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesWithNoMatchInNonEmptyCache_deliversNoResults() {
//
//        let sut = makeSUT()
//
//        let routine = uniqueRoutine()
//        create(routine, into: sut)
//
//        expectReadAllRoutines(with: "Any", or: [], on: sut, toCompleteWith: .success([]))
//    }
//
//
//    func test_coreDataRoutineStore_readRoutinesWithNameOrExercisesTwiceWithNoMatchInNonEmptyCache_deliversNoSideEffects() {
//
//        let sut = makeSUT()
//
//        let routine = uniqueRoutine()
//        create(routine, into: sut)
//
//        expectReadAllRoutines(with: "Any", or: [], on: sut, toCompleteTwiceWith: .success([]))
//    }
    
    
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
    
//
//    @discardableResult
//    private func createRoutineAndRoutineRecord(
//        name: String,
//        routineRecord: RoutineRecord,
//        into sut: CoreDataRoutineStore,
//        file: StaticString = #file,
//        line: UInt = #line) -> RoutineStore.CreateRoutineResult {
//
//        let exp = expectation(description: "Wait for RoutineStore create completion")
//
//        var receivedResult: RoutineStore.CreateRoutineResult = nil
//
//        sut.createRoutineAndRoutineRecord(
//            name: name,
//            routineRecord
//        ) { result in
//
//            receivedResult = result
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1)
//
//        return receivedResult
//    }
    
    
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

