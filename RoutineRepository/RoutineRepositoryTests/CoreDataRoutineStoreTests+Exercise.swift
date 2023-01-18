//
//  CoreDataRoutineStoreTests+Exercise.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import RoutineRepository
import XCTest


extension CoreDataRoutineStoreTests {

    // read all exercises in empty cache
    // read all exercises twice in empty cache
    // read all exercises in nonempty cache
    // read all exercises twice in nonempty cache
    
    func test_coreDataRoutineStore_readExercisesOnEmptyCache_deliversNoResults() {
        
        let sut = makeSUT()
        
        expectReadAllExercises(on: sut, toCompleteWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readExercisesTwiceOnEmptyCache_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expectReadAllExercises(on: sut, toCompleteTwiceWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readExercisesOnNonEmptyCache_deliversCachedExercises() {
        
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        create(exercise, into: sut)
        
        expectReadAllExercises(on: sut, toCompleteWith: .success([exercise]))
    }
    
    
    
    func test_coreDataRoutineStore_readExercisesTwiceOnNonEmptyCache_deliversCachedExercises() {
        
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        create(exercise, into: sut)
        
        expectReadAllExercises(on: sut, toCompleteTwiceWith: .success([exercise]))
    }
    
    
    
    @discardableResult
    private func create(_ exercise: Exercise, into sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> RoutineStore.CreateExerciseResult {
        
        let exp = expectation(description: "Wait for RoutineStore create completion")
        
        var receivedResult: RoutineStore.CreateExerciseResult = nil
        
        sut.createExercise(exercise) { result in
            receivedResult = result
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
    
    
    private func expectReadAllExercises(on sut: CoreDataRoutineStore, toCompleteTwiceWith expectedResult: RoutineStore.ReadExercisesResult, file: StaticString = #file, line: UInt = #line) {
        
        expectReadAllExercises(on: sut, toCompleteWith: expectedResult, file: file, line: line)
        expectReadAllExercises(on: sut, toCompleteWith: expectedResult, file: file, line: line)
    }
}
