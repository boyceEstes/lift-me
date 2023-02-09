//
//  CoreDataRoutineStoreTests+RoutineRecords.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 2/6/23.
//

import XCTest
import RoutineRepository

extension CoreDataRoutineStoreTests {
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithEmptyCache_deliversNoResults() {
        
        // given
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for read all routine records completion")
        
        sut.readAllRoutineRecords { result in
            switch result {
            case let .success(routineRecords):
                XCTAssertEqual(routineRecords, [])
            case let .failure(error):
                XCTFail("Failed with error, \(error)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithEmptyCacheTwice_hasNoSideEffects() {
        
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCache_deliversAllRoutineRecords() {
        
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCacheTwice_deliversAllRoutineRecords() {
        
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInEmptyCache_createsNewRoutineRecord() {
        
        // given
        let sut = makeSUT()

        let exp = expectation(description: "Wait for create routine record completion")
        
        sut.createRoutineRecord { _ in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        
        let exp2 = expectation(description: "Wait for read all routine records completion")
        
        sut.readAllRoutineRecords { result in
            let records = try! result.get()
            
            XCTAssertEqual(records.count, 1)
            exp2.fulfill()
        }
        
        wait(for: [exp2], timeout: 1)
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButNoIncompleteRoutineRecords_createsNewRoutineRecord() {
        
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButOneIncompleteRoutineRecords_updateCompletionDateOfExistingIncompleteRoutineRecordAndcreatesNewRoutineRecord() {
        
    }

    
    private func update(
        _ routineRecord: RoutineRecord,
        with updatedRoutineRecord: RoutineRecord,
        on sut: CoreDataRoutineStore,
        file: StaticString = #file,
        line: UInt = #line) {
    
        let exp = expectation(description: "Wait for RoutineStore update completion")

        sut.updateRoutineRecord(
            id: routineRecord.id,
            with: updatedRoutineRecord.completionDate,
            and: updatedRoutineRecord.exerciseRecords) { receivedError in
                
            XCTAssertNil(receivedError)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expectReadAllRoutineRecords(
        on sut: CoreDataRoutineStore,
        toCompleteWith expectedResult: RoutineStore.ReadAllRoutineRecordsResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "Wait for read all routine records completion")
        
        sut.readAllRoutineRecords { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedRoutineRecords), .success(expectedRoutineRecords)):
                XCTAssertEqual(receivedRoutineRecords, expectedRoutineRecords)
            default:
                XCTFail("Something happened. Expected \(expectedResult), but got \(receivedResult)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
//    private func expectGetIncompleteRoutineRecord(
//        on sut: CoreDataRoutineStore,
//        with creationDate: @escaping () -> Date = Date.init,
//        toCompleteWith expectedResult: RoutineStore.,
//        file: StaticString = #file,
//        line: UInt = #line) {
//
//        let exp = expectation(description: "Wait for RoutineStore read completion")
//
//
//            sut.getIncompleteRoutineRecord(creationDate: creationDate) { result in
//
//            switch (result, expectedResult) {
//            case let (.success(routineRecord), .success(expectedRoutineRecord)):
//                XCTAssertEqual(routineRecord.creationDate, expectedRoutineRecord.creationDate, file: file, line: line)
//                XCTAssertEqual(routineRecord.completionDate, expectedRoutineRecord.completionDate, file: file, line: line)
//                XCTAssertEqual(routineRecord.exerciseRecords, expectedRoutineRecord.exerciseRecords, file: file, line: line)
//
//            default:
//                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
//            }
//
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 1)
//    }
}
