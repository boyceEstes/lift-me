//
//  CreateExerciseUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 4/8/23.
//

import XCTest
import ViewInspector
import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS
import NavigationFlow
@testable import LiftMeApp



class CreateExerciseUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_createExerciseView_saveEmptyNameAndEmptyDescription_isNotPossibleBecauseSaveButtonIsDisabled() throws {
        
        // given/when
        let (sut, _) = makeSUT()
        
        let expectedName = ""
        let expectedDescription = ""
        
        let nameTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "exercise_name").textField()
        try nameTextField.setInput(expectedName)
        
        let descriptionTextField = try sut.inspect().find(viewWithAccessibilityIdentifier: "exercise_description").textField()
        try descriptionTextField.setInput(expectedDescription)

        // then
        let saveButton = try sut.inspect().find(button: "Save")
        XCTAssertTrue(saveButton.isDisabled())
    }
 
    
    func test_createExerciseView_saveNonEmptyNameAndDescription_createsExerciseInDatabaseAndCallsDismiss() throws {
        
        // given
        let (sut, routineStore) = makeSUT()
        let expectedName = "Any Exercise Name"
        let expectedDescription = ""
        
        let exp1 = sut.inspection.inspect { view in
            
            // when pt. 1
            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_name").textField()
            try nameTextField.setInput(expectedName)
            
            let descriptionTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_description").textField()
            try descriptionTextField.setInput(expectedDescription)
            
            // then pt. 1
            let saveButton = try view.find(button: "Save")
            XCTAssertFalse(saveButton.isDisabled())
            
            // when pt. 2
            try saveButton.tap()
            
            // then pt. 2
            XCTAssertEqual(routineStore.requests.count, 1)
            if case let .createExercise(exercise) = routineStore.requests.first {
                XCTAssertEqual(exercise.name, expectedName)
            } else {
                XCTFail("Spy did not retrieve created exercise correctly")
            }
        }

        ViewHosting.host(view: sut)
        wait(for: [exp1], timeout: 0.3)

    }
    
    
    func test_createExerciseView_saveEmptyNameAndNonEmptyDescription_isNotPossibleBecauseSaveButtonIsDisabled() throws {
        
        // given/when
        let (sut, _) = makeSUT()
        
        let expectedName = ""
        let expectedDescription = "Any exercise description"
        
        let exp1 = sut.inspection.inspect { view in
            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_name").textField()
            try nameTextField.setInput(expectedName)
            
            let descriptionTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_description").textField()
            try descriptionTextField.setInput(expectedDescription)
            
            // This has to be run after the onAppear so that the StateObject has time to make the viewModel
            let saveButton = try view.find(button: "Save")
            XCTAssertTrue(saveButton.isDisabled())
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp1], timeout: 0.1)

    }

//    TODO: Update the Exercise model to include a prperty for description
//    func test_createExerciseView_saveNonEmptyNameAndNonEmptyDescription_createsExerciseInDatabaseAndCallsDismiss() throws {
//
//        // given
//        let (sut, routineStore) = makeSUT()
//        let expectedName = "Any Exercise Name"
//        let expectedDescription = "Any exercise description"
//
//        let exp1 = sut.inspection.inspect { view in
//            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_name").textField()
//            try nameTextField.setInput(expectedName)
//
//            let descriptionTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_description").textField()
//            try descriptionTextField.setInput(expectedDescription)
//        }
//
//        ViewHosting.host(view: sut)
//        wait(for: [exp1], timeout: 0.3)
//
//        // when
//        sut.viewModel.saveExercise()
//
//        // then
//        let saveButton = try sut.inspect().find(button: "Save")
//        XCTAssertFalse(saveButton.isDisabled())
//
//        XCTAssertEqual(routineStore.requests.count, 1)
//        if case let .createExercise(exercise) = routineStore.requests.first {
//            XCTAssertEqual(exercise.name, expectedName)
//        } else {
//            XCTFail("Spy did not retrieve created exercise correctly")
//        }
//    }
    
    // MARK: What happens when the View's cancel button is tapped?
//    func test_createExerciseView_cancelTapped_dismissesCreateExerciseViewWithoutSaving() throws {
//
//        // given
//        let (sut, _, exerciseUIComposer) = makeSUT()
//
//        // when
//        let cancelButton = try sut.inspect().find(button: "Cancel")
//        try cancelButton.tap()
//
//        // then
//        // assert Dismiss is called via spy
//        XCTAssertEqual(exerciseUIComposer.messages, [UIComposerMessage.dismissModal])
//
//    }

    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: CreateExerciseView, routineStore: RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = CreateExerciseView(routineStore: routineStore, createExerciseCompletion: { _ in })
        
        return (sut, routineStore)
    }
}
