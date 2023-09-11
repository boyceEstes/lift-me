//
//  ExerciseRecordDisplayOrderPolicyTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 9/4/23.
//

import XCTest
import RoutineRepository



// Order array of exercise records so that they are delivered in the proper order to view
final class ExerciseRecordDisplayOrderPolicyTests: XCTestCase {
    
    func test_exerciseRecordDisplayOrderPolicy_sortByDateWithExerciseRecordsWithNoSetRecords_deliversOriginalOrder() {
        
        // given
        let setRecords = [SetRecord]()
        let exerciseRecord1 = uniqueExerciseRecord(setRecords: setRecords)
        let exerciseRecord2 = uniqueExerciseRecord(setRecords: setRecords)
        let exerciseRecord3 = uniqueExerciseRecord(setRecords: setRecords)
        let unorderedExerciseRecords = [exerciseRecord2, exerciseRecord1, exerciseRecord3]
        
        // when
        let orderedExerciseRecords = ExerciseRecordDisplayOrderPolicy.sortByDate(unorderedExerciseRecords)
        
        // then
        XCTAssertEqual(orderedExerciseRecords, unorderedExerciseRecords)
    }
    
    
    func test_exerciseRecordDisplayOrderPolicy_sortByDateWithUnorderedExerciseRecords_deliversNewestExerciseRecordsFirst() {
        
        // given
        
        let olderSetRecords = [
            uniqueSetRecord(completionDate: Date().adding(days: -2).adding(minutes: -5)),
            uniqueSetRecord(completionDate: Date().adding(days: -2))
        ]
        let olderExerciseRecord = uniqueExerciseRecord(setRecords: olderSetRecords)
            
        let recentSetRecords = [
            uniqueSetRecord(completionDate: Date().adding(minutes: -5)),
            uniqueSetRecord(completionDate: Date())
        ]
        let recentExerciseRecord = uniqueExerciseRecord(setRecords: recentSetRecords)
            
        let unorderedExerciseRecords = [olderExerciseRecord, recentExerciseRecord]
        
        // when
        let orderedExerciseRecords = ExerciseRecordDisplayOrderPolicy.sortByDate(unorderedExerciseRecords)
        
        // then
        let expectedOrder = [recentExerciseRecord, olderExerciseRecord]
        XCTAssertEqual(orderedExerciseRecords, expectedOrder)
    }
    
    
    // Ensure that this ordering orders sets as well
    func test_exerciseRecordDisplayOrderPolicy_sortByDateWithUnorderedExerciseRecordsAndUnorderedSetRecords_deliversOrderedExerciseRecordsAndSetRecords() {
        
        // given
        let olderSetRecord = uniqueSetRecord(completionDate: Date().adding(days: -2).adding(minutes: -5))
        let recentSetRecord = uniqueSetRecord(completionDate: Date().adding(days: -2))
        
        let olderSetRecords = [
            recentSetRecord,
            olderSetRecord
        ]
        var olderExerciseRecord = uniqueExerciseRecord(setRecords: olderSetRecords)
            
        let recentSetRecords = [
            uniqueSetRecord(completionDate: Date().adding(minutes: -5)),
            uniqueSetRecord(completionDate: Date())
        ]
        let recentExerciseRecord = uniqueExerciseRecord(setRecords: recentSetRecords)
            
        let unorderedExerciseRecords = [olderExerciseRecord, recentExerciseRecord]
        
        // when
        let orderedExerciseRecords = ExerciseRecordDisplayOrderPolicy.sortByDate(unorderedExerciseRecords)
        
        // then
        // Should have newly ordered set records
        olderExerciseRecord.setRecords = [olderSetRecord, recentSetRecord]
        let expectedOrder: [ExerciseRecord] = [recentExerciseRecord, olderExerciseRecord]
        XCTAssertEqual(orderedExerciseRecords, expectedOrder)
    }
    
    
    // Ensure that if there is one nil completionDate it will be in one general area
    
}


// Order array of set records so that they are delivered in the proper order to view
final class SetRecordDisplayOrderPolicyTests: XCTestCase {
    
    func test_setRecordDisplayOrderPolicy_sortByDateWithNoSetRecords_deliversEmptyArray() {
        
        // given
        let setRecords = [SetRecord]()
        
        // when
        let orderedSetRecords = SetRecordDisplayOrderPolicy.sortByDate(setRecords)
        
        // then
        XCTAssertEqual(orderedSetRecords, [])
    }
    
    
    func test_setRecordDisplayOrderPolicy_sortByDateWithRecentSetRecordsFirst_deliversOldestSetRecordsFirst() {
        
        // given
        let olderDate = Date().adding(minutes: -5)
        let recentDate = Date()
        let olderSetRecord = uniqueSetRecord(completionDate: olderDate)
        let recentSetRecord = uniqueSetRecord(completionDate: recentDate)
        
        let setRecords = [
            recentSetRecord,
            olderSetRecord
        ]
        
        // when
        let orderedSetRecords = SetRecordDisplayOrderPolicy.sortByDate(setRecords)
        
        // then
        let expectedOrder = [olderSetRecord, recentSetRecord]
        XCTAssertEqual(orderedSetRecords, expectedOrder)
    }
    
    
    func test_setRecordDisplayOrderPolicy_sortByDateWithOlderSetRecordsFirst_deliversOldestSetRecordsFirst() {
        
        // given
        let olderDate = Date().adding(minutes: -5)
        let recentDate = Date()
        let olderSetRecord = uniqueSetRecord(completionDate: olderDate)
        let recentSetRecord = uniqueSetRecord(completionDate: recentDate)
        
        let setRecords = [
            olderSetRecord,
            recentSetRecord
        ]
        
        // when
        let orderedSetRecords = SetRecordDisplayOrderPolicy.sortByDate(setRecords)
        
        // then
        let expectedOrder = [olderSetRecord, recentSetRecord]
        XCTAssertEqual(orderedSetRecords, expectedOrder)
    }
}
