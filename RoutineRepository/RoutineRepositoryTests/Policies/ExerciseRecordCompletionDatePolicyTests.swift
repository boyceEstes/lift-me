//
//  ExerciseCompletionDatePolicyTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 9/2/23.
//

import XCTest
import RoutineRepository



final class ExerciseRecordCompletionDatePolicyTests: XCTestCase {
    
    func test_exerciseRecordCompletionDatePolicy_calculateCompletionDateUsingEmptySetRecords_deliversNil() {
        
        // given
        let setRecords = [SetRecord]()
        
        // when
        let completionDate = ExerciseRecordCompletionDatePolicy.calculateCompletionDate(using: setRecords)
        
        // then
        XCTAssertNil(completionDate)
    }
    
    
    func test_exerciseRecordCompletionDatePolicy_calculateCompletionDateOneSetRecord_deliversSetRecordCompletionDate() {
        
        // given
        let setRecordCompletionDate = Date().adding(days: -1) // messing with date just for fun, shouldn't matter
        let setRecords = [uniqueSetRecord(completionDate: setRecordCompletionDate)]
        
        // when
        let completionDate = ExerciseRecordCompletionDatePolicy.calculateCompletionDate(using: setRecords)
        
        // then
        XCTAssertEqual(completionDate, setRecordCompletionDate)
    }
    
    
    func test_exerciseRecordCompletionDatePolicy_calculateCompletionDateTwoSetRecordsWithDifferentCompletionDatesUnSorted_deliversEarliestCompletionDate() {
        
        // given
        let setRecordCompletionDateEarlier = Date().adding(days: -1)
        let setRecordCompletionDateLater = Date().adding(days: -1).adding(minutes: 3)
        let setRecords = [
            uniqueSetRecord(completionDate: setRecordCompletionDateLater),
            uniqueSetRecord(completionDate: setRecordCompletionDateEarlier)
        ]
        
        // when
        let completionDate = ExerciseRecordCompletionDatePolicy.calculateCompletionDate(using: setRecords)
        
        // then
        XCTAssertEqual(completionDate, setRecordCompletionDateEarlier)
    }
}
