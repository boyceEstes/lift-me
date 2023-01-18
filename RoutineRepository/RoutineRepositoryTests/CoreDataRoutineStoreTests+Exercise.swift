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
    
    func test_coreDataRoutineStore_readExercisesOnEmptyCache_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expectReadAllExercises(on: sut, toCompleteWith: .success([]))
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
}
