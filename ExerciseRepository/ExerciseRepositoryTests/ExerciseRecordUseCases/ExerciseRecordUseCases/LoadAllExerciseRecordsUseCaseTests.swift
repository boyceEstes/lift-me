//
//  LoadAllExerciseRecordsUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 5/2/22.
//

import XCTest
import ExerciseRepository


class LoadAllExerciseRecordsUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_loadAllExerciseRecordsRequest_requestsAllExerciseRecordsFromStore() {
        
        let (sut, store) = makeSut()
        
        sut.loadAllExerciseRecords() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieveAllExerciseRecords])
    }
    
    
    func test_localExerciseRepository_loadAllExerciseRecordsWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()
        
        expect(sut: sut, toCompleteWith: .failure(error)) {
            store.completeRetrieveAllExerciseRecords(with: error)
        }
    }
    
    
    func test_localExerciseRepository_loadAllExerciseRecordsWithEmptyCache_deliversNoExerciseRecords() {
        
        let (sut, store) = makeSut()
        
        expect(sut: sut, toCompleteWith: .success([])) {
            store.completeRetrieveAllExerciseRecordsWithEmptyCache()
        }
    }
    
    
    func test_localExerciseRepository_loadAllExerciseRecords_deliversValidExerciseRecords() {
        
        let (sut, store) = makeSut()
        
        let exerciseRecords = [makeUniqueExerciseRecord(), makeUniqueExerciseRecord()]
        
        expect(sut: sut, toCompleteWith: .success(exerciseRecords)) {
            
            store.completeRetrieveAllExerciseRecords(with: exerciseRecords.toLocal())
        }
    }
    
    
    func test_localExerciseRepository_loadAllExerciseRecordsIsDeallocatedBeforeResult_emptyResult() {
        
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        let error = anyNSError()
        
        var receivedResult = [Result<[ExerciseRecord], Error>]()
        
        sut?.loadAllExerciseRecords() { result in
            receivedResult.append(result)
        }
        
        sut = nil
        store.completeRetrieveAllExerciseRecords(with: error)
                
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    
    // MARK: - Helpers
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalExerciseRepository, store: ExerciseStoreSpy) {
        
        let store = ExerciseStoreSpy()
        let sut = LocalExerciseRepository(exerciseStore: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    
    private func expect(sut: LocalExerciseRepository, toCompleteWith expectedResult: Result<[ExerciseRecord], Error>, file: StaticString = #file, line: UInt = #line, action: () -> Void) {
        
        let exp = expectation(description: "Wait for loadAllExerciseRecords completion")
        
        sut.loadAllExerciseRecords() { result in
            
            switch (result, expectedResult) {
            case let (.success(receivedExerciseRecords), .success(expectedExerciseRecords)):
                XCTAssertEqual(receivedExerciseRecords, expectedExerciseRecords, file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError?, expectedError as NSError?, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
        
    }
}
