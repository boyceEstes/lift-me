//
//  SaveSetRecordUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/6/22.
//

import XCTest
import LiftMeExercises

class SaveSetRecordUseCaseTests: XCTestCase {
    
    
    func test_localExerciseRepository_onCreation_noSideEffects() {

        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_saveSetRecord_requestsSaveSetRecord() {

        let (sut, store) = makeSut()

        let setRecord = makeUniqueSetRecordTuple()
        sut.save(setRecord: setRecord.model) { _ in }

        XCTAssertEqual(store.receivedMessages, [.insert(setRecord: setRecord.local)])
    }
    
    
    func test_localExerciseRepository_saveSetRecordWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()
        
        expect(sut: sut, toCompleteWith: error) {
            store.completeInsertSetRecord(with: error)
        }
    }
    
    
    func test_localExerciseRepository_saveSetRecordWithoutError_deliversNoError() {
        
        let (sut, store) = makeSut()

        expect(sut: sut, toCompleteWith: nil) {
            store.completeInsertSetRecord()
        }
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
        
        let setRecord = makeUniqueSetRecord()
        let exp = expectation(description: "Wait for Save Exercise Record to complete")
        var receivedError: Error?
        
        sut.save(setRecord: setRecord) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }

}
