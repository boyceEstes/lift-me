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
 */

extension CreateRoutineView: Inspectable {}


class CreateRoutineUIIntegrationTests: XCTestCase {
    
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_createRoutineView_init_displaysCreateRoutine() {
        
        // given/when
        let sut = CreateRoutineView()
        let expectedText = "Create Routine"
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(text: expectedText))
    }
}
