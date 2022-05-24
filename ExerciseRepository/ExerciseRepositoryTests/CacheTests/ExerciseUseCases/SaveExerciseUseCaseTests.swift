//
//  SaveExerciseUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 4/13/22.
//

import XCTest
import ExerciseRepository


class SaveExerciseUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_saveExercise_requestsCacheInsertion() {
        
        let (sut, store) = makeSut()
        let exercise = makeUniqueExerciseTuple()
        
        sut.save(exercise: exercise.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.insert(exercise: exercise.local)])
    }
    
    
    func test_localExerciseRepository_saveExerciseWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()
        
        expect(sut: sut, store: store, toCompleteWith: error) {
            store.completeInsertion(with: error)
        }
    }
    
    
    func test_localExerciseRepository_saveExercise_successfullySaves() {
        
        let (sut, store) = makeSut()

        expect(sut: sut, store: store, toCompleteWith: nil) {
            store.completeInsertion()
        }
    }
    
    
    func test_localExerciseRepository_saveExerciseWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
       
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let exercise = makeUniqueExercise()
        
        var receivedErrors = [Error?]()
        
        sut?.save(exercise: exercise) { error in
            receivedErrors.append(error)
        }
        sut = nil
        
        store.completeInsertion(with: error)
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
        let exp = expectation(description: "Wait for save to complete")
        
        var receivedError: Error?
        sut.save(exercise: exercise) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }

}
