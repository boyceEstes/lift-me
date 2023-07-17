//
//  ExerciseDetailViewUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 2/12/23.
//

import XCTest
import ViewInspector
import SwiftUI
import LiftMeRoutinesiOS
import RoutineRepository
@testable import LiftMeApp


final class ExercieDetailViewUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_exerciseDetailView_viewAppears_willRequestAllExerciseRecordsForThisExerciseFromRoutineStore() {
        
        // GIVEN
        let exercise = uniqueExercise()
        let (sut, routineStore) = makeSUT(with: exercise)

        
        let exp = sut.inspection.inspect { sut in
            
            // THEN
            // assert that the routine store has been requested for .readAllRoutineRecords
            XCTAssertEqual(routineStore.requests, [.readAllExerciseRecords(exercise)])
        }
        
        // WHEN
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
//    
//    func test_exerciseDetailView_readExerciseRecordsWithNonEmptyCache_rendersRowsForEachExerciseRecordSaved() {
//        
//        // GIVEN
//        let exercise = uniqueExercise()
//        let (sut, routineStore, _) = makeSUT(with: exercise)
//        
//        let setRecords = [uniqueSetRecord(), uniqueSetRecord()]
//        let exerciseRecords = [
//            uniqueExerciseRecord(setRecords: setRecords, exercise: exercise),
//            uniqueExerciseRecord(setRecords: setRecords, exercise: exercise)
//        ]
//        
//        let exp = sut.inspection.inspect { sut in
//            
//            let exercisesRowViewsBefore = sut.findAll(BasicExerciseRowView.self)
//            XCTAssertEqual(exercisesRowViewsBefore.count, 0)
//            
//            // WHEN
//            routineStore.completeReadExerciseRecordsForExercise(with: exerciseRecords)
//            
//            // THEN
//            let exercisesRowViewsAfter = sut.findAll(BasicExerciseRowView.self)
//            XCTAssertEqual(exercisesRowViewsAfter.count, exercises.count)
//        }
//        
//        ViewHosting.host(view: sut)
//        
//        wait(for: [exp], timeout: 1)
//    }
}


// MARK: - Helpers

private func makeSUT(with exercise: Exercise, file: StaticString = #file, line: UInt = #line) -> (view: ExerciseDetailView, routineStore: RoutineStoreSpy) {

    let routineStore = RoutineStoreSpy()
    let sut = ExerciseDetailView(routineStore: routineStore, exercise: exercise)

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

    return (sut, routineStore)
}
