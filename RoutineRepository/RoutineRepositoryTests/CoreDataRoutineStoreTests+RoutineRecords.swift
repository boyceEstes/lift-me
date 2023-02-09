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
    
//    
//    func test_coreDataRoutineStore_createRoutineRecordInEmptyCacheWithCompletionDateAndExerciseRecord_createsNewRoutineRecord() {
//
//        // given
//        let sut = makeSUT()
//        let exercise = uniqueExercise()
//        let exerciseRecord = uniqueExerciseRecord(exercise: exercise)
//        
//        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [exerciseRecord])
//
//        // when/then
//        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
//        
//        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
//    }
//    
//    
//    func test_coreDataRoutineStore_createRoutineRecordInEmptyCacheWithNoCompletionDateAndExerciseRecord_createsNewRoutineRecord() { }
//    
//    func test_coreDataRoutineStore_createRoutineRecordInEmptyCacheWithCompletionDateAndNoExerciseRecords_deliversCannotCreateRecordWithoutExercisesError() {}
//
//
//    
    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButNoIncompleteRoutineRecords_createsNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let routineRecordCompleted = RoutineRecord(id: UUID(), creationDate: Date().adding(days: -1), completionDate: Date(), exerciseRecords: [])
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])
        
        createRoutineRecord(routineRecordCompleted, on: sut)
        
        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
    }
    
    
    // TODO: Complete this test by creating a way to test that the completion Date for the incompleted exercise is the same as we expect it to be
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButOneIncompleteRoutineRecords_updateCompletionDateOfExistingIncompleteRoutineRecordAndcreatesNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let routineRecordIncompleted = RoutineRecord(id: UUID(), creationDate: Date().adding(days: -1), completionDate: nil, exerciseRecords: [])
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date(), completionDate: nil, exerciseRecords: [])

        createRoutineRecord(routineRecordIncompleted, on: sut)
        
        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
    }
    
            
    func test_coreDataRoutineStore_updateRoutineRecordWithCompletionDate_updatesRoutineRecordsCompletionDate() {
        
        // given
        let sut = makeSUT()
        
        let uuid = UUID()
        let creationDate = Date()
        let completionDate = Date()
        
        let routineRecordBefore = RoutineRecord(id: uuid, creationDate: creationDate, completionDate: nil, exerciseRecords: [])
        let routineRecordAfter = RoutineRecord(id: uuid, creationDate: creationDate, completionDate: completionDate, exerciseRecords: [])
        
        createRoutineRecord(routineRecordBefore, on: sut)

        // when
        XCTAssertNil(updateRoutineRecord(routineRecordBefore.id, completionDate: completionDate, on: sut))
        
        // then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecordAfter]))
    }
    
    
     func test_coreDataRoutineStore_updateRoutineRecordOnEmptyCache_deliversCannotUpdateRoutineRecordThatDoesNotExistError() {
         
         // given
         let sut = makeSUT()
         
         let uuid = UUID()
         let creationDate = Date()
         let completionDate = Date()
         
         let routineRecordBefore = RoutineRecord(id: uuid, creationDate: creationDate, completionDate: nil, exerciseRecords: [])
         let routineRecordAfter = RoutineRecord(id: uuid, creationDate: creationDate, completionDate: completionDate, exerciseRecords: [])

         // when
         let error = updateRoutineRecord(routineRecordBefore.id, completionDate: completionDate, on: sut)
         
         // then
         XCTAssertEqual(error as? NSError, CoreDataRoutineStore.Error.cannotUpdateRoutineRecordThatDoesNotExist as NSError)
     }
    

    // TODO: Figure out why we are not getting ManagedExerciseRecord data whenever we are deciphering ManagedRoutineRecord
    func test_coreDataRoutineStore_updateRoutineRecordWithNewExerciseRecordsAndNoCompletionDate_updatesRoutineRecordsExerciseRecords() {

        // given
        let sut = makeSUT()
        
        let uuid = UUID()
        let creationDate = Date()
//        let completionDate = Date()
        let exercise = uniqueExercise()
        let exerciseRecord = uniqueExerciseRecord(exercise: exercise)
        
        let routineRecordBefore = RoutineRecord(id: uuid, creationDate: creationDate, completionDate: nil, exerciseRecords: [])
        let routineRecordAfter = RoutineRecord(id: uuid, creationDate: creationDate, completionDate: nil, exerciseRecords: [exerciseRecord])

        create(exercise, into: sut)
        createRoutineRecord(routineRecordBefore, on: sut)

        // when
        XCTAssertNil(updateRoutineRecord(routineRecordBefore.id, completionDate: nil, exerciseRecords: [exerciseRecord], on: sut))
        
        // then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecordAfter]))
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

    
    @discardableResult
    private func updateRoutineRecord(
        _ routineRecordID: UUID,
        completionDate: Date?,
        exerciseRecords: [ExerciseRecord] = [],
        on sut: CoreDataRoutineStore,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Error? {
        
        let exp = expectation(description: "Wait for RoutineStore update completion")
        
        var receivedError: Error?
        
        sut.updateRoutineRecord(
            id: routineRecordID,
            updatedCompletionDate: completionDate,
            updatedExerciseRecords: exerciseRecords
        ) { error in
            
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        return receivedError
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
