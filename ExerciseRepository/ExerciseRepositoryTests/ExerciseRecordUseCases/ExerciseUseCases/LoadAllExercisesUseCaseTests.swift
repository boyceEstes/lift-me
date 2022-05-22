//
//  LoadAllExercisesUseCaseTests.swift
//  
//
//  Created by Boyce Estes on 4/15/22.
//

import XCTest
import LiftMeExercises

class LoadAllExercisesUseCaseTests: XCTestCase {
    
    func test_localExerciseRepository_onCreation_noSideEffects() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    func test_localExerciseRepository_loadAllExercises_requestsStoreAllRetrieval() {
        
        let (sut, store) = makeSut()

        sut.loadAllExercises() { _ in }
        XCTAssertEqual(store.receivedMessages, [.retrieveAll])
    }
    
    
    func test_localExerciseRepository_loadAllExercisesWithError_deliversError() {
        
        let (sut, store) = makeSut()
        let error = anyNSError()
        
        expect(sut: sut, store: store, expectedResult: .failure(error)) {
            store.completeRetrieveAll(with: error)
        }
    }
    
    
    func test_localExerciseRepository_loadAllExerciseesWithEmptyCache_returnNoExercises() {
        
        let (sut, store) = makeSut()
        
        expect(sut: sut, store: store, expectedResult: .success([])) {
            store.completeRetrieveAllWithEmptyCache()
        }
    }
    
    
    func test_localExerciseRepository_loadAllExercises_deliversValidExercises() {
        
        let (sut, store) = makeSut()
        let exercises = makeUniqueExercisesTuple()
        
        expect(sut: sut, store: store, expectedResult: .success(exercises.models)) {
            store.completeRetrieveAll(with: exercises.local)
        }
    }
    
    
    func test_localExerciseRepository_loadAllExercisesIsDeallocatedBeforeResult_emptyResult() {
        
        let store = ExerciseStoreSpy()
        var sut: LocalExerciseRepository? = LocalExerciseRepository(exerciseStore: store)
        
        let error = anyNSError()
        var receivedResults = [ExerciseRepository.ExerciseResult]()
        sut?.loadAllExercises { result in
            receivedResults.append(result)
        }
        
        sut = nil
        store.completeRetrieveAll(with: error)
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    
    // MARK: - Helpers
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalExerciseRepository, store: ExerciseStoreSpy) {
        
        let store = ExerciseStoreSpy()
        let sut = LocalExerciseRepository(exerciseStore: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    
    func expect(sut: LocalExerciseRepository, store: ExerciseStoreSpy, expectedResult: Result<[Exercise], Error>, action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for loadAllExercises completion")
        
        sut.loadAllExercises() { result in
            
            switch (result, expectedResult) {
            
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError?, expectedError as NSError?, file: file, line: line)
                
            case let (.success(receivedExercises), .success(expectedExercises)):
                XCTAssertEqual(receivedExercises, expectedExercises, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}
