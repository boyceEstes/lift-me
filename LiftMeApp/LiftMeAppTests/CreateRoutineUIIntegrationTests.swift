//
//  CreateRoutineUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 11/11/22.
//

import XCTest
import SwiftUI
import ViewInspector
import LiftMeRoutinesiOS
@testable import LiftMeApp
import RoutineRepository

/*
 * TODO: Create Routine displays the correct title
 * TODO: Test that we have correct text in body
 * [x] - is there a textfield with name as the placeholder?
 * [ ] - is there a textfield with desc as the placeholder
 * [x] - does cancel button exist
 * [ ] - Will save save the routine in core data?
 */


class CreateRoutineUIIntegrationTests: XCTestCase {
    
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }

    
    func test_createRoutineView_init_displaysRoutineNameTextField() {
        
        // given/when
        let (sut, _) = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(text: "Name"))
    }
    
    
    
    func test_createRoutineView_init_displaysDescriptionTextField() throws {
        
        // given/when
        let (sut, _) = makeSUT()
        
        XCTAssertNoThrow(try sut.inspect().find(text: "Description"))
    }
    
    
    func test_createRoutineView_init_containsCancelButton() throws {
        
        // given/when
        let (sut, _) = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(button: "Cancel"))
    }
    
    
    func test_createRoutineView_noNameNoDescriptionNoExercises_hasDisabledSaveButton() throws {
        
        // given
        let (sut, _) = makeSUT()
        
        // when
        // It is in its basic state (of no information)
        
        // then
        let saveButton = try sut.inspect().find(button: "Save")
        XCTAssertTrue(saveButton.isDisabled())
    }
    
    
    func test_createRoutineView_NoNameNoDescriptionExercises_hasDisabledSaveButton() throws {
        
        // given
        let (sut, _) = makeSUT()
        
        sut.inspection.inspect { sut in
            
            let addExerciseButton = try sut.find(button: "Add")
            // when - this would normally make the next `AddExerciseView` pop up, but instead we made this closure just return an exercise for the tests
            try addExerciseButton.tap()
            
            // then - there should
            let exerciseRows = sut.findAll { view in
                try view.accessibilityIdentifier() == "exercise_row"
            }
            XCTAssertEqual(exerciseRows.count, 1)
            
            let saveButton = try sut.find(button: "Save")
            XCTAssertTrue(saveButton.isDisabled())
        }
    }
    
    
    func test_createRoutineView_NameNoDescriptionNoExercises_hasDisabledSaveButton() throws {
        
        // given
        let (sut, _) = makeSUT()
        
        // when
        // Enter name
        let expectedName = "Any Routine"
        let exp = sut.inspection.inspect { view in
            
            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "routine_name").textField()
            try nameTextField.setInput(expectedName)
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 0.3)
        
        // then
        let saveButton = try sut.inspect().find(button: "Save")
        XCTAssertTrue(saveButton.isDisabled())
    }
    
    
    func test_createRoutineView_NameNoDescriptionExercises_hasEnabledSaveButton() throws {
        
        // given
        let (sut, _) = makeSUT()
        
        // when
        // Enter name
        let expectedName = "Any Routine"
        let exp = sut.inspection.inspect { sut in
            
            let nameTextField = try sut.find(viewWithAccessibilityIdentifier: "routine_name").textField()
            try nameTextField.setInput(expectedName)
        }
        
        
        let exp2 = sut.inspection.inspect { sut in
            // Add exercise
            // This would normally make the next `AddExerciseView` pop up, but instead we made this closure just return an exercise for the tests
            try sut.find(button: "Add").tap()
            let exerciseRows = sut.findAll { view in
                try view.accessibilityIdentifier() == "exercise_row"
            }
            XCTAssertEqual(exerciseRows.count, 1)
            
            // then
            let saveButton = try sut.find(button: "Save")
            XCTAssertFalse(saveButton.isDisabled())
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp, exp2], timeout: 0.3)
    }
    
    
    func test_createRoutineView_saveRoutineWithTextFieldNameEntered_requestsToSaveRoutineWithSameName() throws {
        
        // given
        let (sut, routineRepository) = makeSUT()
        let expectedName = "DeadLift"

        // when
        let exp = sut.inspection.inspect { sut in
            
            let nameTextField = try sut.find(viewWithAccessibilityIdentifier: "routine_name").textField()
            try nameTextField.setInput(expectedName)
        }
        
        let exp2 = sut.inspection.inspect { sut in
            // Add exercise
            // This would normally make the next `AddExerciseView` pop up, but instead we made this closure just return an exercise for the tests
            try sut.find(button: "Add").tap()
            let exerciseRows = sut.findAll { view in
                try view.accessibilityIdentifier() == "exercise_row"
            }
            XCTAssertEqual(exerciseRows.count, 1)
            
            let saveButton = try sut.find(button: "Save")
            try saveButton.tap()
            
            // This will with index out-of-bounds if we have not hooked up button to save
            routineRepository.completeSaveRoutineSuccessfully()
            
            // then
            let requests = routineRepository.requests
            // TODO: Make sure that the inputted text is what is saved - ViewInspector is making this difficult right now
            // There should be at least one saveRoutine request
            XCTAssertNotEqual(requests, [])
        }

        
        ViewHosting.host(view: sut)
        wait(for: [exp, exp2], timeout: 0.3)
    }
    
    
    // MARK: - Helpers
    private func makeSUT() -> (CreateRoutineView, RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = CreateRoutineView(
            routineStore: routineStore,
            routineRecord: nil,
            superDismiss: nil,
            goToAddExercise: { someFunctionToAddExercisesToList in
                // Instead of navigating to another view and allowing that view to trigger this method, just do it immediately
                // This parameter will be passed in to the closure when the method is called in `goToAddExercise` in CreateRoutineView
                someFunctionToAddExercisesToList([uniqueExercise(name:"any")])
            },
            goToExerciseDetail: { _ in }
        )
        
        return (sut, routineStore)
    }
}

