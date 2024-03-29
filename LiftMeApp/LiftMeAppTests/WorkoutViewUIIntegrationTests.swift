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
    
    
    func test_workoutView_addingExercisesToRoutineRecordWithEmptyExerciseList_displaysExercises() {

        // given
        // A routine record with no exercises
        let (sut, _) = makeSUT()
        let addedExercises = [uniqueExercise(), uniqueExercise()]

        let exp = sut.inspection.inspect { sut in

            let exercisesWithSetsBefore = sut.findAll(ExerciseRecordView.self)
            XCTAssertEqual(exercisesWithSetsBefore.count, 0)

            // when
            // Exercise(s) is added from add exercise screen
            try sut.actualView().viewModel.addExercisesCompletion(exercises: addedExercises)

            // then
            // the routine record will append the new added exercises and display them
            let exerciseRecordViewAfter = sut.findAll(ExerciseRecordView.self)
            XCTAssertEqual(exerciseRecordViewAfter.count, 2)
        }

        ViewHosting.host(view: sut)

        wait(for: [exp], timeout: 1)
    }
    
    
    func test_workoutView_addingExercisesToRoutineRecord_displaysOneSetRecordViewByDefault() {
        
        // given
        // A routine record with no exercises
        let (sut, _) = makeSUT()
        let addedExercise = [uniqueExercise()]

        let exp = sut.inspection.inspect { sut in

            let setRecordsBefore = sut.findAll(SetRecordView.self)
            XCTAssertEqual(setRecordsBefore.count, 0)

            // when
            // Exercise(s) is added from add exercise screen
            try sut.actualView().viewModel.addExercisesCompletion(exercises: addedExercise)

            // then
            // the routine record will append the new added exercises and display them
            let setRecordsAfter = sut.findAll(SetRecordView.self)
            XCTAssertEqual(setRecordsAfter.count, 1)
        }

        ViewHosting.host(view: sut)

        wait(for: [exp], timeout: 1)
    }
    
    
    func test_exerciseRecordView_didTapAddSetRecordButton_displayAnAdditionalSetRecordView() {
        
        // GIVEN
        // A routine record with no exercises
        let (sut, _) = makeSUT()
        let addedExercise = [uniqueExercise()]

        let exp = sut.inspection.inspect { sut in

            let setRecordsBefore = sut.findAll(SetRecordView.self)
            XCTAssertEqual(setRecordsBefore.count, 0)

            // Exercise(s) is added from add exercise screen
            try sut.actualView().viewModel.addExercisesCompletion(exercises: addedExercise)

            // the routine record will append the new added exercises and display them
            let setRecordsAfter = sut.findAll(SetRecordView.self)
            XCTAssertEqual(setRecordsAfter.count, 1)
            
            
            // WHEN
            let addSetButton = try sut.find(button: "Add Set")
            try addSetButton.tap()
            
            // THEN
            let setRecordsAfter2 = sut.findAll(SetRecordView.self)
            XCTAssertEqual(setRecordsAfter2.count, 2)
        }

        ViewHosting.host(view: sut)

        wait(for: [exp], timeout: 1)
    }
    
    // TODO: Figure out how to test alerts correctly
//    func test_workoutView_didTapSaveButtonWithEmptySetRecords_willNotAllowSaveToProceed() throws {
//
//        // given
//        // A routine record with no exercises
//        let (sut, _, _) = makeSUT()
//        let addedExercise = [uniqueExercise()]
//
//        let exp = sut.inspection.inspect { sut in
//
//            // Exercise(s) is added from add exercise screen
//            try sut.actualView().viewModel.addExercisesCompletion(exercises: addedExercise)
//
//            // The routine record will append the new added exercises and display them
//            let saveButton = try sut.find(button: "Save")
//
//            // WHEN
//            try saveButton.tap()
//
//            let alert = try sut.alert()
//            XCTAssertEqual(try alert.title().string(), "Not Yet")
//            XCTAssertEqual(try alert.message().text().string(), "Make sure you fill out all of your sets")
//        }
//
//        ViewHosting.host(view: sut)
//
//        wait(for: [exp], timeout: 1)
//    }
    
    
    // TODO: Make a shortcut helper method to call to get save button
    
    func test_workoutView_noExerciseRecords_willKeepTheButtonDisabled() throws {
        
        // given
        let (sut, _) = makeSUT()
        
        // when
        let saveButton = try sut.inspect().find(button: "Save")
        
        // then
        XCTAssertTrue(saveButton.isDisabled())
    }
    
    
    func test_workoutView_withExerciseRecords_saveButtonisEnabled() throws {
        
        // given
        let (sut, _) = makeSUT()
        let exercise = uniqueExercise()
        
        let exp = sut.inspection.inspect { sut in
            
            try sut.actualView().viewModel.addExercisesCompletion(exercises: [exercise])
            
            // when
            let saveButton = try sut.find(button: "Save")
            
            // then
            XCTAssertFalse(saveButton.isDisabled())
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 1)
    }


    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: WorkoutView, routineStore: RoutineStoreSpy) {

        let routineStore = RoutineStoreSpy()
        let sut = WorkoutView(routineStore: routineStore, goToAddExercise: { _ in }, goToCreateRoutineView: { _ in }, goToExerciseDetails: { _ in })
//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineStore)
    }
    
}
