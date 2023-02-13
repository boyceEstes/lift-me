//
//  CoreDataRoutineStoreTests+ExerciseRecord.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 2/12/23.
//

import XCTest
import RoutineRepository

extension CoreDataRoutineStoreTests {
    
    
    func test_coreDataRoutineStore_readExerciseRecordsForExerciseInEmptyCache_deliversSuccessWithEmptyArray() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        
        // when/then
        expectReadExerciseRecords(for: exercise, on: sut, toCompleteWith: .success([]))
    }

    
    func test_coreDataRoutineStore_readExerciseRecordsForExerciseThatExistsInNonEmptyCache_deliversAllExerciseRecordsForExercise() {
        
    }
    
    // MARK: - Helpers

    private func expectReadExerciseRecords(
        for exercise: Exercise,
        on sut: CoreDataRoutineStore,
        toCompleteWith expectedResult: RoutineStore.ReadExerciseRecordsResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Wait for read exercise records for exercise completion")
        
        sut.readExerciseRecords(for: exercise) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedRoutineRecords), .success(expectedRoutineRecords)):
                XCTAssertEqual(receivedRoutineRecords, expectedRoutineRecords, file: file, line: line)
            default:
                XCTFail("Something happened. Expected \(expectedResult), but got \(receivedResult)", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
