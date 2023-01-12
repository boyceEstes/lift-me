//
//  WorkoutViewUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/11/23.
//

import XCTest
import ViewInspector
import SwiftUI
import LiftMeRoutinesiOS
@testable import LiftMeApp


extension WorkoutView: Inspectable { }


final class WorkoutViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_workoutView_init_displaysAddExerciseButton() {
        
        // given
        let sut = makeSUT().view
        
        // when/then
        XCTAssertNoThrow(try sut.inspect().find(viewWithId: "add-exercise-button"))
    }
    
    // TODO: Test to make sure that there is a message when there are no exercises available
    func test_workoutView_withNoExercises_displaysMessageToAddExercise() {
        
        // given
        // setup SUT with no exercises (default behavior for custom workout)
        let sut = makeSUT().view
        
        // when/then
        XCTAssertNoThrow(try sut.inspect().find(text: "Try adding an exercise!"))
    }
    
    
    func test_workoutView_tapAddButton_navigatesToAddExerciseView() throws {

        // given
        let (sut, workoutNavigationFlow) = makeSUT()
        let button = try sut.inspect().find(viewWithId: "add-exercise-button").button()

        // when
        try button.tap()

        // then
        XCTAssertEqual(
            workoutNavigationFlow.modallyDisplayedView,
            WorkoutNavigationFlow.SheetyIdentifier.addExercise
        )
    }


    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: WorkoutView, navigationFlow: WorkoutNavigationFlow) {

        let workoutUIComposer = WorkoutUIComposer()
        let workoutNavigationFlow = workoutUIComposer.navigationFlow
        let sut = workoutUIComposer.makeWorkoutView()

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, workoutNavigationFlow)
    }
    
}
