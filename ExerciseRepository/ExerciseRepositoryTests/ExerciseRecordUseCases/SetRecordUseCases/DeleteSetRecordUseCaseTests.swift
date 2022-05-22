//
//  DeleteSetRecordUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/4/22.
//

import XCTest
import LiftMeExercises


class DeleteSetRecordUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_removeSetRecord_requestsToDeleteExercise() {
        
        let (sut, store) = makeSut()
        
        let setRecord = makeUniqueSetRecordTuple()
        sut.remove(setRecord: setRecord.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.delete(setRecord: setRecord.local)])
    }
    
    
    func test_localExerciseRepository_removeSetRecordWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()

        expect(sut: sut, toCompleteWith: error) {
            store.completeDeleteSetRecord(with: error)
        }
    }
    
    
    func test_localExerciseRepository_removeSetRecordWithoutError_deliversNoError() {
        
        let (sut, store) = makeSut()

        expect(sut: sut, toCompleteWith: nil) {
            store.completeDeleteSetRecord()
        }
    }
    
    
    func test_localExerciseRepository_removeSetRecordWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
       
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let setRecord = makeUniqueSetRecordTuple()
        
        var receivedErrors = [Error?]()
        
        sut?.remove(setRecord: setRecord.model) { error in
            receivedErrors.append(error)
        }
        sut = nil
        
        store.completeDeleteSetRecord(with: error)
        XCTAssertTrue(receivedErrors.isEmpty, "Expected no results, got \(receivedErrors) instead")
    }
    
    
    // MARK: - Helpers
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: LocalExerciseRepository, store: ExerciseStoreSpy) {
        
        let store = ExerciseStoreSpy()
        let sut = LocalExerciseRepository(exerciseStore: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    
    private func expect(sut: LocalExerciseRepository, toCompleteWith expectedError: NSError?, after action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let setRecord = makeUniqueSetRecordTuple()
        let exp = expectation(description: "Wait for remove set record completion")
        var receivedError: Error?
        
        sut.remove(setRecord: setRecord.model) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
