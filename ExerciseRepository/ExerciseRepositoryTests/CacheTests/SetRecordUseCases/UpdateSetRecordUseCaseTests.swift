//
//  UpdateSetRecordUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/7/22.
//

import XCTest
import ExerciseRepository

class UpdateSetUURecordUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_updateExercise_requestsUpdateExercise() {
        
        let (sut, store) = makeSut()
        let setRecord = makeUniqueSetRecordTuple()
        
        sut.update(setRecord: setRecord.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.update(setRecord: setRecord.local)])
    }
    
    
    func test_localExerciseRepository_updateExerciseWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()

        expect(sut: sut, toCompleteWith: error) {
            store.completeUpdateSetRecord(with: error)
        }
    }
    
    
    func test_localExerciseRepository_updateExercise_deliversNoError() {
        
        let (sut, store) = makeSut()

        expect(sut: sut, toCompleteWith: nil) {
            store.completeUpdateSetRecord()
        }
    }
    
    
    func test_localExerciseRepository_updateSetRecordWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
       
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let setRecord = makeUniqueSetRecordTuple()
        
        var receivedErrors = [Error?]()
        
        sut?.update(setRecord: setRecord.model) { error in
            receivedErrors.append(error)
        }
        sut = nil
        
        store.completeUpdateSetRecord(with: error)
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
        
        let setRecord = makeUniqueSetRecordTuple()
        let exp = expectation(description: "Wait for update to complete")
        
        var receivedError: Error?
        sut.update(setRecord: setRecord.model) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
