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
        let (sut, _, workoutNavigationFlow) = makeSUT()
        let button = try sut.inspect().find(viewWithId: "add-exercise-button").button()

        // when
        try button.tap()

        // then
        XCTAssertEqual(
            workoutNavigationFlow.modallyDisplayedView,
            WorkoutNavigationFlow.SheetyIdentifier.addExercise
        )
    }
    
    
    func test_workoutView_viewWillAppear_createsRoutineRecord() {
        
        // given
        let (sut, routineStore, _) = makeSUT()
        
        let exp = sut.inspection.inspect { view in
            // then
            XCTAssertEqual(routineStore.requests, [.createRoutineRecord])
        }
        
        // when
        ViewHosting.host(view: sut)

        wait(for: [exp], timeout: 1)
    }


    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: WorkoutView, routineStore: RoutineStoreSpy, navigationFlow: WorkoutNavigationFlow) {

        let workoutUIComposer = WorkoutUIComposerWithSpys()
        let workoutNavigationFlow = workoutUIComposer.navigationFlow
        let sut = workoutUIComposer.makeWorkoutView()
        let routineStore: RoutineStoreSpy = workoutUIComposer.routineStore as! RoutineStoreSpy

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineStore, workoutNavigationFlow)
    }
    
}
