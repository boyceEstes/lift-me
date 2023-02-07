//
//  CoreDataRoutineStoreTests+RoutineRecords.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 2/6/23.
//

import XCTest
import RoutineRepository

extension CoreDataRoutineStoreTests {
    
    func test_coreDataRoutineStore_getIncompleteRoutineRecordWithEmptyCache_createsNewRoutineRecord() {
        
        let sut = makeSUT()
        let creationDate = Date()
        // The reason that we are putting this as a function is so that we will return the same value whenever this method is called
        // This prevents small differences in dates
        let expectedCreationDate: () -> Date = { creationDate }
        let expectedCompletionDate: Date? = nil
        // Not testing ID as that is going to be randomly generated in creation, but we can test the other values that we are expecting
        let expectedRoutineRecord = uniqueRoutineRecord(creationDate: expectedCreationDate(), completionDate: expectedCompletionDate)

        expectGetIncompleteRoutineRecord(
            on: sut,
            with: expectedCreationDate,
            toCompleteWith: .success(expectedRoutineRecord))
    }
    
    
    func test_coreDataRoutineStore_getIncompleteRoutineRecordWithNonEmptyCacheButNoIncompleteRoutineRecords_createsNewRoutineRecord() {
        
    }
    
    
    func test_coreDataRoutineStore_getIncompleteRoutineRecordWithNonEmptyCacheAndAnIncompleteRoutineRecord_deliversIncompleteRoutineRecord() {
        
    }
    
    
    func test_coreDataRoutineStore_getIncompleteRoutineRecordTwiceWithNonEmptyCacheAndAnIncompleteRoutineRecord_deliversNoSideEffects() {
        
    }
    
    
    private func expectGetIncompleteRoutineRecord(
        on sut: CoreDataRoutineStore,
        with creationDate: @escaping () -> Date = Date.init,
        toCompleteWith expectedResult: RoutineStore.GetIncompleteRoutineRecordResult,
        file: StaticString = #file,
        line: UInt = #line) {
        
        let exp = expectation(description: "Wait for RoutineStore read completion")
            

            sut.getIncompleteRoutineRecord(creationDate: creationDate) { result in
            
            switch (result, expectedResult) {
            case let (.success(routineRecord), .success(expectedRoutineRecord)):
                XCTAssertEqual(routineRecord.creationDate, expectedRoutineRecord.creationDate, file: file, line: line)
                XCTAssertEqual(routineRecord.completionDate, expectedRoutineRecord.completionDate, file: file, line: line)
                XCTAssertEqual(routineRecord.exerciseRecords, expectedRoutineRecord.exerciseRecords, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}
