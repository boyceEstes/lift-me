//
//  CoreDataRoutineStoreTests+RoutineRecords.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 2/6/23.
//

import XCTest
import RoutineRepository

extension CoreDataRoutineStoreTests {
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInEmptyCache_createsNewRoutineRecord() {
        
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButNoIncompleteRoutineRecords_createsNewRoutineRecord() {
        
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButOneIncompleteRoutineRecords_updateCompletionDateOfExistingIncompleteRoutineRecordAndcreatesNewRoutineRecord() {
        
    }
 
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithEmptyCache_deliversNoResults() {
        
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithEmptyCacheTwice_hasNoSideEffects() {
        
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCache_deliversAllRoutineRecords() {
        
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCacheTwice_deliversAllRoutineRecords() {
        
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
