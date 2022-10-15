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
        
        expect(sut, toCompleteWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnEmptyCacheTwice_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expect(sut, toCompleteTwiceWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnNonEmtpyCache_deliversCachedRoutines() {
        
        let sut = makeSUT()
        
        // TODO: Since we have not implmented ManagedExercises, this uniqueRotuine will have to not have any for now
        let routine = uniqueRoutine(exercises: []).local
        create(routine, into: sut)
        expect(sut, toCompleteWith: .success([routine]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnNonEmptyCacheTwice_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        // TODO: Since we have not implmented ManagedExercises, this uniqueRotuine will have to not have any for now
        let routine = uniqueRoutine(exercises: []).local
        create(routine, into: sut)
        expect(sut, toCompleteTwiceWith: .success([routine]))
    }
    
    
    func test_coreDataRoutineStore_createRoutineInEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        let routine = uniqueRoutine(exercises: []).local
        let createError = create(routine, into: sut)
        XCTAssertNil(createError, "Creating routine in empty cache delivers error, \(createError!)")
    }
    
    
    func test_coreDataRoutineStore_createRoutineInNonEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        create(uniqueRoutine(exercises: []).local, into: sut)

        let createError = create(uniqueRoutine(exercises: []).local, into: sut)
        
        XCTAssertNil(createError, "Creating routine in empty cache delivers error, \(createError!)")
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataRoutineStore {

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
    private func create(_ routine: LocalRoutine, into sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> RoutineStore.CreateRoutineResult {
        
        let exp = expectation(description: "Wait for RoutineStore create completion")
        
        var receivedResult: RoutineStore.CreateRoutineResult = nil
        
        sut.create(routine) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedResult
    }
    
    
    private func expect(_ sut: CoreDataRoutineStore, toCompleteWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        
        let exp = expectation(description: "Wait for RoutineStore read completion")
        
        sut.readAllRoutines() { result in
            
            switch (result, expectedResult) {
            case let (.success(routines), .success(expectedRoutines)):
                XCTAssertEqual(routines, expectedRoutines, "Expected \(expectedRoutines) but got \(routines) instead", file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expect(_ sut: CoreDataRoutineStore, toCompleteTwiceWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toCompleteWith: expectedResult, file: file, line: line)
        expect(sut, toCompleteWith: expectedResult, file: file, line: line)
    }
}

