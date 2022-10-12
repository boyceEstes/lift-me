//
//  LoadAllRoutinesUseCaseTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/10/22.
//

import XCTest
import RoutineRepository

class LoadAllRoutinesUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let (_, routineStore) = makeSUT()
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }

    
    func test_routineRepository_readAllRoutines_requestsReadAllRoutine() {
        
        let (sut, routineStore) = makeSUT()
        
        sut.loadAllRoutines { _ in }
        
        XCTAssertEqual(routineStore.receivedMessages, [RoutineStoreSpy.ReceivedMessage.readAllRoutines], "Expected readAllRoutines message, but got \(routineStore.receivedMessages) instead")
    }
    
    
    func test_routineRepository_readAllRoutinesWithFailure_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        let expectedError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(expectedError)) {
            
            routineStore.completeReadAllRoutines(with: expectedError)
        }
    }
    
    
    func test_routineRepository_readAllRoutines_deliversCachedRoutines() {
        
        let (sut, routineStore) = makeSUT()
        
        let routines = uniqueRoutines()
        
        expect(sut, toCompleteWith: .success(routines.model)) {
            
            routineStore.completeReadAllRoutines(with: routines.local)
        }
    }
    
    
    // MARK: -- Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalRoutineRepository, routineStore: RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = LocalRoutineRepository(routineStore: routineStore)
        
        trackForMemoryLeaks(routineStore, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, routineStore)
    }
    
    
    private func expect(_ sut: LocalRoutineRepository, toCompleteWith expectedResult: RoutineRepository.LoadAllRoutinesResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for loadAllRoutines completion")
        
        sut.loadAllRoutines { result in
            
            switch (result, expectedResult) {
                
            case let (.success(receivedRoutines), .success(expectedRoutines)):
                XCTAssertEqual(receivedRoutines, expectedRoutines, "Expected \(expectedRoutines), got \(receivedRoutines) instead", file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, "Expected \(expectedError), got \(receivedError) instead", file: file, line: line)
                
            default:
                XCTFail("Expected to receive failure, but got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
            
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func uniqueRoutines() -> (model: [Routine], local: [LocalRoutine]) {
        
        let routines = [uniqueRoutine(), uniqueRoutine()]
        let model = routines.map { $0.0 }
        let local = routines.map { $0.1 }
        
        return (model, local)
    }
}
