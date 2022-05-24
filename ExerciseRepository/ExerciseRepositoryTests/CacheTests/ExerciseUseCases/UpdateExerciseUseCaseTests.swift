//
//  UpdateExerciseUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/7/22.
//

import XCTest
import ExerciseRepository

class UpdateExerciseUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_updateExercise_requestsUpdateExercise() {
        
        let (sut, store) = makeSut()
        let exercise = makeUniqueExerciseTuple()
        
        sut.update(exercise: exercise.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.update(exercise: exercise.local)])
    }
    
    
    func test_localExerciseRepository_updateExerciseWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()
        
        expect(sut: sut, toCompleteWith: error) {
            store.completeUpdateExercise(with: error)
        }
    }
    
    
    func test_localExerciseRepository_updateExercise_deliversNoError() {
        
        let (sut, store) = makeSut()
        
        expect(sut: sut, toCompleteWith: nil) {
            store.completeUpdateExercise()
        }
    }
    
    
    func test_localExerciseRepository_updateExerciseWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
       
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let exercise = makeUniqueExerciseTuple()
        
        var receivedErrors = [Error?]()
        
        sut?.update(exercise: exercise.model) { error in
            receivedErrors.append(error)
        }
        sut = nil
        
        store.completeUpdateExercise(with: error)
        XCTAssertTrue(receivedErrors.isEmpty)
    }
    
    
    
    // MARK: - Helpers
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalExerciseRepository, store: ExerciseStoreSpy) {
        
        let store = ExerciseStoreSpy()
        let sut = LocalExerciseRepository(exerciseStore: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    
    private func expect(sut: LocalExerciseRepository, toCompleteWith expectedError: NSError?, after action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exercise = makeUniqueExerciseTuple()
        let exp = expectation(description: "Wait for update to complete")
        
        var receivedError: Error?
        sut.update(exercise: exercise.model) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
