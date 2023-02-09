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
        
        // when/then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithEmptyCacheTwice_hasNoSideEffects() {
        
        // given
        let sut = makeSUT()
        
        // when/then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCache_deliversAllRoutineRecords() {
        
        // given
        let sut = makeSUT()
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])

        createRoutineRecord(routineRecord, on: sut)
        
        // when/then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCacheTwice_hasNoSideEffects() {
        
        // given
        let sut = makeSUT()
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])

        createRoutineRecord(routineRecord, on: sut)
        
        // when/then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInEmptyCache_createsNewRoutineRecord() {

        // given
        let sut = makeSUT()
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])

        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButNoIncompleteRoutineRecords_createsNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let routineRecordCompleted = RoutineRecord(id: UUID(), creationDate: Date().adding(days: -1), completionDate: Date(), exerciseRecords: [])
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])
        
        createRoutineRecord(routineRecordCompleted, on: sut)
        
        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButOneIncompleteRoutineRecords_updateCompletionDateOfExistingIncompleteRoutineRecordAndcreatesNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let routineRecordIncompleted = RoutineRecord(id: UUID(), creationDate: Date().adding(days: -1), completionDate: nil, exerciseRecords: [])
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])

        createRoutineRecord(routineRecordIncompleted, on: sut)
        
        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
    }
    
    
    // MARK: - Helpers
    
    @discardableResult
    private func createRoutineRecord(_ routineRecord: RoutineRecord, on sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        
        let exp = expectation(description: "Wait for create routine record completion")
        
        var receivedError: Error?
        
        sut.createRoutineRecord(routineRecord) { error in
            
            receivedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        return receivedError
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
                XCTAssertEqual(receivedRoutineRecords, expectedRoutineRecords, file: file, line: line)
            default:
                XCTFail("Something happened. Expected \(expectedResult), but got \(receivedResult)", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
