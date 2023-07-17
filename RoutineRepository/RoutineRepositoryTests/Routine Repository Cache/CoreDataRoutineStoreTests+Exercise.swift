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

    // MARK: - Read exercises
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
    
    
    
    // MARK: - Create Exercises
    // create exercise in empty cache
    // create exercise in nonempty cache
    // TODO: create unique exercise with matching name in cache
    
    func test_coreDataRoutineStore_createExerciseOnEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        let createError = create(exercise, into: sut)
        
        XCTAssertNil(createError, "Creating exercise in empty cache delivers error, \(createError!)")
    }
    
    
    func test_coreDataRoutineStore_createExerciseOnNonEmptyCache_deliversNoError() {
        
        let sut = makeSUT()
        
        create(uniqueExercise(), into: sut)
        
        let exercise = uniqueExercise()
        let createError = create(exercise, into: sut)
        
        XCTAssertNil(createError, "Creating exercise in nonempty cache delivers error, \(createError!)")
    }
    
    
    func test_coreDataRoutineStore_createExerciseOnNonEmptyCacheWithSameExerciseName_deliversExerciseAlreadyExistsError() {
        
        // given
        let sut = makeSUT()
        
        let exercise = uniqueExercise(name: "The Sagi Six Way")
        let exerciseWithSameNameAndDifferentID = uniqueExercise(name: exercise.name)
        
        // when
        create(exercise, into: sut)
        let createExerciseWithSameNameError = create(exerciseWithSameNameAndDifferentID, into: sut)
        
        // then
        XCTAssertEqual(createExerciseWithSameNameError as? NSError, CoreDataRoutineStore.Error.exerciseWithNameAlreadyExists as NSError)
        
    }
    
    
    func test_coreDataRoutineStore_createExerciseOnNonEmptyCacheWithSameExerciseID_deliversExerciseAlreadyExistsError() {
        
        // given
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        let exerciseWithSameIDAndDifferentName = uniqueExercise(id: exercise.id)
        
        // when
        create(exercise, into: sut)
        let createExerciseWithSameNameError = create(exerciseWithSameIDAndDifferentName, into: sut)
        
        // then
        XCTAssertEqual(createExerciseWithSameNameError as? NSError, CoreDataRoutineStore.Error.exerciseWithNameAlreadyExists as NSError)
        
    }
    
    
    func test_coreDataRoutineStore_deleteExerciseOnEmptyCache_failsWithCannotFindExerciseError() {
        
        // given
        let sut = makeSUT()
        
        // when
        let exerciseID = uniqueExercise().id
        let deleteError = delete(exerciseID, into: sut)
        
        // then
        let expectedError = CoreDataRoutineStore.Error.cannotFindExercise
        XCTAssertEqual(deleteError as? NSError, expectedError as NSError)
    }
    
    
    func test_coreDataRoutineStore_deleteExerciseNotInNonEmptyCache_failsWithCannotFindExerciseError() {
        
        // given
        let sut = makeSUT()
        let anyExercise = uniqueExercise()
        create(anyExercise, into: sut)
        
        // when
        let differentExerciseID = uniqueExercise().id
        let deleteError = delete(differentExerciseID, into: sut)
        
        // then
        let expectedError = CoreDataRoutineStore.Error.cannotFindExercise
        XCTAssertEqual(deleteError as? NSError, expectedError as NSError)
    }
    

    func test_coreDataRoutineStore_deleteExerciseInNonEmptyCache_deletesExerciseFromCache() {

        // given
        let sut = makeSUT()
        let anyExercise = uniqueExercise()
        create(anyExercise, into: sut)

        // when
        let anyExerciseID = anyExercise.id
        let deleteError = delete(anyExerciseID, into: sut)

        // then
        expectReadAllExercises(on: sut, toCompleteWith: .success([]))
    }
    
    
    @discardableResult
    func create(_ exercise: Exercise, into sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> RoutineStore.CreateExerciseResult {
        
        let exp = expectation(description: "Wait for RoutineStore create completion")
        
        var receivedResult: RoutineStore.CreateExerciseResult = nil
        
        sut.createExercise(exercise) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedResult
    }
    
    
    @discardableResult
    func delete(_ exerciseID: UUID, into sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> RoutineStore.DeleteExerciseResult {
        
        let exp = expectation(description: "Wait for RoutineStore create completion")
        
        var receivedResult: RoutineStore.DeleteExerciseResult = nil
        
        sut.deleteExercise(by: exerciseID) { result in
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
