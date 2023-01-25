//
//  AddExerciseViewUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/20/23.
//

import XCTest
import ViewInspector
import SwiftUI
import LiftMeRoutinesiOS
@testable import LiftMeApp


final class AddExerciseViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_addExerciseView_init_loadsAllExercises() {
        
        // given/when
        let sut = makeSUT()
        
        // then
        // display x many cells
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: AddExerciseView, navigationFlow: WorkoutNavigationFlow) {

        let workoutUIComposer = WorkoutUIComposer()
        let workoutNavigationFlow = workoutUIComposer.navigationFlow
        let sut = workoutUIComposer.makeAddExerciseView()

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, workoutNavigationFlow)
    }
}
