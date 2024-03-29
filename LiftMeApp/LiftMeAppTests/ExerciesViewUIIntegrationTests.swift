//
//  ExerciesViewUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 2/12/23.
//

import XCTest
import ViewInspector
import SwiftUI
import LiftMeRoutinesiOS
@testable import LiftMeApp


final class ExerciesViewUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_exercisesView_viewAppears_willRequestAllExercisesFromRoutineStore() {
        
        // GIVEN
        let (sut, routineStore) = makeSUT()
        
        let exp = sut.inspection.inspect { sut in
            
            // THEN
            // assert that the routine store has been requested for .readAllRoutineRecords
            XCTAssertEqual(routineStore.requests, [.getExerciseDataSource])
        }
        
        // WHEN
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_exerciseView_readRoutineRecordsWithNonEmptyCache_rendersRowsForEachRoutineRecordSaved() {
        
        // GIVEN
        let (sut, routineStore) = makeSUT()
        
        let exercises = [uniqueExercise(), uniqueExercise(), uniqueExercise()]
        
        let exp = sut.inspection.inspect { sut in
            
            let exercisesRowViewsBefore = sut.findAll(BasicExerciseRowView.self)
            XCTAssertEqual(exercisesRowViewsBefore.count, 0)
            
            // WHEN
            routineStore.completeReadAllExercises(with: exercises)
            
            // THEN
            let exercisesRowViewsAfter = sut.findAll(BasicExerciseRowView.self)
            XCTAssertEqual(exercisesRowViewsAfter.count, exercises.count)
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: ExercisesView, routineStore: RoutineStoreSpy) {

        let routineStore = RoutineStoreSpy()
        let sut = ExercisesView(routineStore: routineStore, goToExerciseDetailView: { _ in }, goToCreateExerciseView: { } )

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineStore)
    }
}
