//
//  DeleteExerciseUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/4/22.
//

import XCTest
import LiftMeExercises


class DeleteExerciseUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_removeExercise_requestsToDeleteExercise() {
        
        let (sut, store) = makeSut()
        let exercise = makeUniqueExerciseTuple()
        
        sut.remove(exercise: exercise.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.delete(exercise: exercise.local)])
    }
    
    
    func test_localExerciseRepository_removeExerciseWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()

        expect(sut: sut, store: store, toCompleteWith: error) {
            store.completeDeleteExercise(with: error)
        }
    }
    
    
    func test_localExerciseRepository_removeExerciseWithNoError_deliversNoError() {
        
        let (sut, store) = makeSut()
        
        expect(sut: sut, store: store, toCompleteWith: nil) {
            store.completeDeleteExercise()
        }
    }
    
    
    func test_localExerciseRepository_removeExerciseWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
       
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let exercise = makeUniqueExercise()
        
        var receivedErrors = [Error?]()
        
        sut?.remove(exercise: exercise) { error in
            receivedErrors.append(error)
        }
        sut = nil
        
        store.completeDeleteExercise(with: error)
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
    
    
    private func expect(sut: LocalExerciseRepository, store: ExerciseStore, toCompleteWith expectedError: NSError?, after action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exercise = makeUniqueExercise()
        let exp = expectation(description: "Wait for remove to complete")
        
        var receivedError: Error?
        sut.remove(exercise: exercise) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }

}


