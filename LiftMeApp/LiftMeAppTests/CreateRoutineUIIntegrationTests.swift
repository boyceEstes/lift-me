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

extension CreateRoutineView: Inspectable {}


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
    
    
    // TODO: Can I test if dismiss is called?
    func test_createRoutineView_init_containsCancelButton() throws {
        
        // given/when
        let (sut, _) = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(button: "Cancel"))
    }
    
    
    func test_createRoutineView_saveRoutineWithTextFieldNameEntered_requestsToSaveRoutineWithSameName() throws {
        
        // given
        let (sut, routineRepository) = makeSUT()
        let expectedName = "DeadLift"
//        let expectedRoutine = uniqueRoutine(name: expectedName).model
        
        let saveButton = try sut.inspect().find(button: "Save")
        //        let descriptionTextField = try sut.inspect().find(text: "Description")
        
        // when
        try sut
            .inspect()
            .find(ViewType.TextField.self)
            .setInput(expectedName)
        
        try saveButton.tap()
        
        // This will with index out-of-bounds if we have not hooked up button to save
        routineRepository.completeSaveRoutineSuccessfully()
        
        // then
        let requests = routineRepository.requests
        // TODO: Make sure that the inputted text is what is saved - ViewInspector is making this difficult right now
        // There should be at least one saveRoutine request
        XCTAssertNotEqual(requests, [])
    }
    
    
    func makeSUT() -> (CreateRoutineView, RoutineStoreSpy) {
        
        let homeUIComposer = CreateRoutineUIComposerWithSpys()
        let routineStore: RoutineStoreSpy = homeUIComposer.routineStore as! RoutineStoreSpy
        
        let sut = homeUIComposer.makeCreateRoutineView(routineRecord: nil, superDismiss: nil)
        
        return (sut, routineStore)
    }
}

