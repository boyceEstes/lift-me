//
//  SaveExerciseRecordUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 4/18/22.
//

import XCTest
import ExerciseRepository

class SaveExerciseRecordUseCaseTests: XCTestCase {
    
    
    func test_localExerciseRepository_onCreation_noSideEffects() {

        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_saveExerciseRecord_requestsExerciseRecord() {

        let (sut, store) = makeSut()

        let exerciseRecord = makeUniqueExerciseRecordTuple()
        
        sut.save(exerciseRecord: exerciseRecord.model) { _ in }

        XCTAssertEqual(store.receivedMessages, [.insert(exerciseRecord: exerciseRecord.local)])
    }
    
    
    func test_localExerciseRepository_saveExerciseRecordWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()
        
        expect(sut: sut, toCompleteWith: error) {
            store.completeExerciseRecordInsertion(with: error)
        }
    }
    
    
    func test_localExerciseRepository_saveExerciseRecord_successfullySaves() {
        
        let (sut, store) = makeSut()
        
        expect(sut: sut, toCompleteWith: nil) {
            store.completeExerciseRecordInsertion()
        }
    }
    
    
    func test_localExerciseRepository_saveExerciseRecordWithErrorAfterSutWasDeallocated_doesNotDeliverError() {
        
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        let exerciseRecord = makeUniqueExerciseRecord()
        
        var receivedErrors = [Error?]()
        sut?.save(exerciseRecord: exerciseRecord, completion: { error in
            receivedErrors.append(error)
        })
        
        sut = nil
        store.completeExerciseRecordInsertion(with: error)
        
        XCTAssertTrue(receivedErrors.isEmpty)
    }
    
    
    // MARK: - Helpers
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: LocalExerciseRepository, store: ExerciseStoreSpy) {
        
        let store = ExerciseStoreSpy()
        let sut = LocalExerciseRepository(exerciseStore: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    
    
    private func expect(sut: LocalExerciseRepository, toCompleteWith expectedError: NSError?, after action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exerciseRecord = makeUniqueExerciseRecordTuple()
        
        let exp = expectation(description: "Wait for Save Exercise Record to complete")
        var receivedError: Error?
        
        sut.save(exerciseRecord: exerciseRecord.model) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
