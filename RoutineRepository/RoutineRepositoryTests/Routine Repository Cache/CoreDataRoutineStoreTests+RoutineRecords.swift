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
        
        let exercise = uniqueExercise()
        let routineRecord = uniqueRoutineRecord(exercise: exercise)
        
        create(exercise, into: sut)
        
        createRoutineRecord(routineRecord, on: sut)
        
        // when/then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
    }
    
    
    func test_coreDataRoutineStore_readAllRoutineRecordsWithNonEmptyCacheTwice_hasNoSideEffects() {
        
        // given
        let sut = makeSUT()
        
        let exercise = uniqueExercise()
        let routineRecord = uniqueRoutineRecord(exercise: exercise)
        
        create(exercise, into: sut)

        createRoutineRecord(routineRecord, on: sut)
        
        // when/then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
    }
    

    func test_coreDataRoutineStore_createRoutineRecordCompletionDateAndExerciseRecordWithoutExerciseSaved_deliversErrorCannotFindExercise() {

        // given
        let sut = makeSUT()
        
        let routineRecord = uniqueRoutineRecord()
        
        let error = CoreDataRoutineStore.Error.cannotFindExercise
        
        // when/then
        XCTAssertEqual(createRoutineRecord(routineRecord, on: sut) as? NSError, error as NSError)
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordInEmptyCacheWithCompletionDateAndExerciseRecord_createsNewRoutineRecord() {

        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        let routineRecord = uniqueRoutineRecord(exercise: exercise)
        
        // exercise record has a non-optional relationship for exercise to exist first
        create(exercise, into: sut)

        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
        
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
    }


    func test_coreDataRoutineStore_createRoutineRecordInEmptyCacheWithExerciseRecordButNoCompletionDate_createsNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        let routineRecord = uniqueRoutineRecord(exercise: exercise)
        
        // exercise record has a non-optional relationship for exercise to exist first
        create(exercise, into: sut)

        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
        
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecord]))
    }
    

    func test_coreDataRoutineStore_createRoutineRecordInEmptyCacheWithCompletionDateAndNoExerciseRecords_deliverscannotCreateRoutineRecordWithNoExerciseRecordsError() {
        
        
        // given
        let sut = makeSUT()
        let routineRecord = RoutineRecord(id: UUID(), creationDate: Date().adding(days: -1), completionDate: nil, exerciseRecords: [])
        
        let error = CoreDataRoutineStore.Error.cannotCreateRoutineRecordWithNoExerciseRecords
        
        // when/then
        XCTAssertEqual(createRoutineRecord(routineRecord, on: sut) as? NSError, error as NSError)
    }

    
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButNoIncompleteRoutineRecords_createsNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        
        let routineRecordCompleted = uniqueRoutineRecord(creationDate: Date().adding(days: -1), completionDate: Date(), exercise: exercise)
        let routineRecord = uniqueRoutineRecord(exercise: exercise)
        
        create(exercise, into: sut)
        
        createRoutineRecord(routineRecordCompleted, on: sut)
        
        // when/then
        XCTAssertNil(createRoutineRecord(routineRecord, on: sut))
    }
    
    
    func test_coreDataRoutineStore_createRoutineRecordWithNoSetRecords_deliversCannotCreateRoutineRecordWithNoSetRecordsError() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        
        let exerciseRecord = uniqueExerciseRecord(setRecords: [], exercise: exercise) // Exercise record has no sets
        let routineRecordCompleted = uniqueRoutineRecord(creationDate: Date().adding(days: -1), completionDate: Date(), exerciseRecords: [exerciseRecord])
        
        create(exercise, into: sut)
        
        // when
        let error = createRoutineRecord(routineRecordCompleted, on: sut)
        
        // then
        XCTAssertEqual(error as? NSError, CoreDataRoutineStore.Error.cannotCreateRoutineRecordWithNoSetRecords as NSError)
        
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([]))
    }
    
    
    // TODO: Complete this test by creating a way to test that the completion Date for the incompleted exercise is the same as we expect it to be
    func test_coreDataRoutineStore_createRoutineRecordWithCreationDateInNonEmptyCacheButOneIncompleteRoutineRecords_updateCompletionDateOfExistingIncompleteRoutineRecordAndcreatesNewRoutineRecord() {
        
        // given
        let sut = makeSUT()
        let exercise = uniqueExercise()
        
        let routineRecordIncompleted = uniqueRoutineRecord(completionDate: nil, exercise: exercise)
        let routineRecord = uniqueRoutineRecord(creationDate: Date().adding(days: -1), completionDate: Date(), exercise: exercise)

        create(exercise, into: sut)
        
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
        
        let exercise = uniqueExercise()
        let exerciseRecord = uniqueExerciseRecord(exercise: exercise)
        
        let routineRecordBefore = uniqueRoutineRecord(
            id: uuid,
            creationDate: creationDate,
            completionDate: nil,
            exerciseRecords: [exerciseRecord]
        )
        let routineRecordAfter = uniqueRoutineRecord(
            id: uuid,
            creationDate: creationDate,
            completionDate: completionDate,
            exerciseRecords: [exerciseRecord]
        )
        
        create(exercise, into: sut)
        
        createRoutineRecord(routineRecordBefore, on: sut)

        // when
        XCTAssertNil(updateRoutineRecord(
            routineRecordBefore.id,
            completionDate: completionDate,
            exerciseRecords: [exerciseRecord],
            on: sut)
        )
        
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

         // when
         let error = updateRoutineRecord(routineRecordBefore.id, completionDate: completionDate, on: sut)
         
         // then
         XCTAssertEqual(error as? NSError, CoreDataRoutineStore.Error.cannotUpdateRoutineRecordThatDoesNotExist as NSError)
     }
    

    // TODO:
    func test_coreDataRoutineStore_updateRoutineRecordWithNewExerciseRecordsAndNoCompletionDate_updatesRoutineRecordsExerciseRecords() {

        // given
        let sut = makeSUT()
        
        let uuid = UUID()
        let creationDate = Date()
//        let completionDate = Date()
        
        let exerciseBefore = uniqueExercise()
        let exerciseRecordBefore = uniqueExerciseRecord(exercise: exerciseBefore)
        let routineRecordBefore = uniqueRoutineRecord(id: uuid, creationDate: creationDate, exerciseRecords: [exerciseRecordBefore])
        
        let exerciseAfter = uniqueExercise()
        let exerciseRecordAfter = uniqueExerciseRecord(exercise: exerciseAfter)
        let routineRecordAfter = uniqueRoutineRecord(id: uuid, creationDate: creationDate, exerciseRecords: [exerciseRecordAfter])

        create(exerciseBefore, into: sut)
        create(exerciseAfter, into: sut)
        
        createRoutineRecord(routineRecordBefore, on: sut)

        // when
        XCTAssertNil(updateRoutineRecord(routineRecordBefore.id, completionDate: nil, exerciseRecords: [exerciseRecordAfter], on: sut))
        
        // then
        expectReadAllRoutineRecords(on: sut, toCompleteWith: .success([routineRecordAfter]))
    }
    
    
    // MARK: - Helpers
    
    @discardableResult
    func createRoutineRecord(_ routineRecord: RoutineRecord, on sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        
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
