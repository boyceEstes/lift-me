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
        
        create(exercise, into: sut)
        
        // when/then
        expectReadExerciseRecords(for: exercise, on: sut, toCompleteWith: .success([]))
    }

    
    func test_coreDataRoutineStore_readExerciseRecordsForExerciseThatDoesNotExist_deliversCannotFindExerciseRecordsForExerciseThatDoesNotExistError() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        let error = CoreDataRoutineStore.Error.cannotFindExerciseRoutinesForExerciseThatDoesNotExist
        
        // when/then
        expectReadExerciseRecords(
            for: exercise,
            on: sut,
            toCompleteWith: .failure(error)
        )
    }
    
    
    func test_coreDataRoutineStore_readExerciseRecordsForExerciseThatExistsInNonEmptyCache_deliversAllExerciseRecordsForExercise() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        let exerciseRecords = [uniqueExerciseRecord(exercise: exercise)]
        
        let routineRecord = uniqueRoutineRecord(exerciseRecords: exerciseRecords)
        
        create(exercise, into: sut)
        createRoutineRecord(routineRecord, on: sut)
        
        // when/then
        expectReadExerciseRecords(for: exercise, on: sut, toCompleteWith: .success(exerciseRecords))
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
            case let (.success(receivedExerciseRecords), .success(expectedExerciseRecords)):
                XCTAssertEqual(receivedExerciseRecords, expectedExerciseRecords, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
            default:
                XCTFail("Something happened. Expected \(expectedResult), but got \(receivedResult)", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
