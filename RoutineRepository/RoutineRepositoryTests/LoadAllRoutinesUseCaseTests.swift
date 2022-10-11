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

    
    func test_routineRepository_readAllRoutines_sendsReadAllRoutineMessageToStore() {
        
        let (sut, routineStore) = makeSUT()
        
        sut.loadAllRoutines { _ in }
        
        XCTAssertEqual(routineStore.receivedMessages, [RoutineStoreSpy.ReceivedMessage.readAllRoutines], "Expected readAllRoutines message, but got \(routineStore.receivedMessages) instead")
    }
    
    
    func test_routineRepository_readAllRoutinesWithFailure_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        let expectedError = anyNSError()
        
        let exp = expectation(description: "Wait for loadAllRoutines completion")
        sut.loadAllRoutines { result in
            
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError, "Expected \(expectedError), got \(receivedError) instead")
            default:
                XCTFail("Expected to receive \(expectedError), but got \(result) instead")
            }
            
            exp.fulfill()
        }
            
        routineStore.completeReadAllRoutines(with: expectedError)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    
    // MARK: -- Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalRoutineRepository, routineStore: RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = LocalRoutineRepository(routineStore: routineStore)
        
        trackForMemoryLeaks(routineStore, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, routineStore)
    }
}
