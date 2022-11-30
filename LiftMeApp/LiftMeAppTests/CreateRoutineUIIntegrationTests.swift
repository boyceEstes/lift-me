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

    
    func test_createRoutineView_init_displaysRoutineNameTextField() throws {
        
        // given/when
        let sut = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(text: "Name"))
    }
    
    
    
    func test_createRoutineView_init_displaysDescriptionTextField() throws {
        
        // given/when
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.inspect().find(text: "Description"))
    }
    
    
    // TODO: Can I test if dismiss is called?
    func test_createRoutineView_init_containsCancelButton() throws {
        
        // given/when
        let sut = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(button: "Cancel"))
    }
    
    
    func makeSUT() -> CreateRoutineView {
        
        return CreateRoutineView()
    }
}
