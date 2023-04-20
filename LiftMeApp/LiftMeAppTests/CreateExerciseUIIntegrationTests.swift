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


extension CreateExerciseView: Inspectable { }


class CreateExerciseUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_createExerciseView_saveEmptyNameAndEmptyDescription_isNotPossibleBecauseSaveButtonIsDisabled() throws {
        
        // given/when
        let (sut, _, _) = makeSUT()
        
        let expectedName = ""
        let expectedDescription = ""
        
        let exp1 = sut.inspection.inspect { view in
            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_name").textField()
            try nameTextField.setInput(expectedName)
            
            let descriptionTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_description").textField()
            try descriptionTextField.setInput(expectedDescription)
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp1], timeout: 0.3)

        // then
        let saveButton = try sut.inspect().find(button: "Save")
        XCTAssertTrue(saveButton.isDisabled())
    }
 
    
    func test_createExerciseView_saveNonEmptyNameAndDescription_createsExerciseInDatabaseAndCallsDismiss() throws {
        
        // given
        let (sut, routineStore, _) = makeSUT()
        let expectedName = "Any Exercise Name"
        let expectedDescription = ""
        
        let exp1 = sut.inspection.inspect { view in
            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_name").textField()
            try nameTextField.setInput(expectedName)
            
            let descriptionTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_description").textField()
            try descriptionTextField.setInput(expectedDescription)
        }

        ViewHosting.host(view: sut)
        wait(for: [exp1], timeout: 0.3)
        // when
        sut.viewModel.saveExercise()
        
        // then
        let saveButton = try sut.inspect().find(button: "Save")
        XCTAssertFalse(saveButton.isDisabled())
        
        XCTAssertEqual(routineStore.requests.count, 1)
        if case let .createExercise(exercise) = routineStore.requests.first {
            XCTAssertEqual(exercise.name, expectedName)
        } else {
            XCTFail("Spy did not retrieve created exercise correctly")
        }
    }
    
    
    func test_createExerciseView_saveEmptyNameAndNonEmptyDescription_isNotPossibleBecauseSaveButtonIsDisabled() throws {
        
        // given/when
        let (sut, _, _) = makeSUT()
        
        let expectedName = ""
        let expectedDescription = "Any exercise description"
        
        let exp1 = sut.inspection.inspect { view in
            let nameTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_name").textField()
            try nameTextField.setInput(expectedName)
            
            let descriptionTextField = try view.find(viewWithAccessibilityIdentifier: "exercise_description").textField()
            try descriptionTextField.setInput(expectedDescription)
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp1], timeout: 0.3)

        // then
        let saveButton = try sut.inspect().find(button: "Save")
        XCTAssertTrue(saveButton.isDisabled())
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
    
    func test_createExerciseView_cancelTapped_dismissesCreateExerciseViewWithoutSaving() throws {
        
        // given
        let (sut, _, exerciseUIComposer) = makeSUT()
        
        // when
        let cancelButton = try sut.inspect().find(button: "Cancel")
        try cancelButton.tap()
        
        // then
        // assert Dismiss is called via spy
        XCTAssertEqual(exerciseUIComposer.messages, [UIComposerMessage.dismissModal])
        
    }

    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: CreateExerciseView, routineStore: RoutineStoreSpy, exerciseUIComposer: ExerciseUIComposerWithSpys) {
        
        // Can come from the AddExerciseView or the exerciseListView from ExerciseUIComposer
        let exerciseUIComposer = ExerciseUIComposerWithSpys(baseState: .createExerciseViewDisplayed)
        let exerciseNavigationFlow = exerciseUIComposer.navigationFlow
        
        let sutAsSomeView = exerciseNavigationFlow.displaySheet(for: exerciseNavigationFlow.modallyDisplayedView!) // Should always have this set from composer initializer
        let sutAsStackNavigationView = sutAsSomeView as? StackNavigationView<CreateExerciseView, ExerciseNavigationFlow>
        let sut = sutAsStackNavigationView!.content
        
        let routineStore: RoutineStoreSpy = exerciseUIComposer.routineStore as! RoutineStoreSpy
        
        return (sut, routineStore, exerciseUIComposer)
    }
}
