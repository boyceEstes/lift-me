//
//  StopwatchHHmmssViewTests.swift
//  LiftMeRoutinesiOSTests
//
//  Created by Boyce Estes on 7/18/23.
//

import XCTest
import ViewInspector
import SwiftUI
// This component should be internal only
@testable import LiftMeRoutinesiOS


final class StopwatchHHmmssViewTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_stopwatchHHmmssView_initialization_containsLabelToDisplayHHmmsssDuration() {
        
        // given/when
        let sut = StopwatchHHmmssView(startDate: Date())
        // then
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "time_duration_label"))
    }
    
//
//    func test_stopwatchHHmmssView_initialization_containsClockImage() {
//
//        // given/when
//        let sut = StopwatchHHmmssView()
//        // then
//        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "HHmmssDuration"))
//    }
//
//
//    func test_stopwatchHHmmssView_updateViewWhenTimerFires_delivers00Hours00Minutes01Seconds() {
//
//        // given
//        let sut = StopwatchHHmmssView()
//        // when
//
//    }
    
    
//    func test_stopwatchHHmmssView_
}
