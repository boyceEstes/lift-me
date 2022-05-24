//
//  DeleteExerciseRecordUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/4/22.
//

import XCTest
import ExerciseRepository


class DeleteExerciseRecordUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_removeExerciserecord_requestsToDeleteExerciseRecord() {
        
        let (sut, store) = makeSut()
        let exerciseRecord = makeUniqueExerciseRecordTuple()
        
        sut.remove(exerciseRecord: exerciseRecord.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.delete(exerciseRecord: exerciseRecord.local)])
    }
    
    
    func test_localExerciseRepository_removeExerciseRecordWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()

        expect(sut: sut, store: store, toCompleteWith: error) {
            store.completeDeleteExerciseRecord(with: error)
        }
    }
    
    
    func test_localExerciseRepository_removeExerciseRecordWithNoError_deliversNoError() {
        
        let (sut, store) = makeSut()

        expect(sut: sut, store: store, toCompleteWith: nil) {
            store.completeDeleteExerciseRecord()
        }
    }
    
    
    func test_localExerciseRepository_removeExerciseRecordWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
       
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let exerciseRecord = makeUniqueExerciseRecordTuple()
        
        var receivedErrors = [Error?]()
        
        sut?.remove(exerciseRecord: exerciseRecord.model) { error in
            receivedErrors.append(error)
        }
        sut = nil
        
        store.completeDeleteExerciseRecord(with: error)
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
        
        let exerciseRecord = makeUniqueExerciseRecordTuple()
        let exp = expectation(description: "Wait for remove to complete")
        
        var receivedError: Error?
        sut.remove(exerciseRecord: exerciseRecord.model) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}


