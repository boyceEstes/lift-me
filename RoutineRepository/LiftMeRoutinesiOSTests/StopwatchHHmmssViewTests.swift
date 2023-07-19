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
        let sut = makeSUT()
        // then
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "time_duration_label"))
    }
    
    
    func test_stopwatchHHmmssView_initialization_displays00Hours00Minutes00Seconds() throws {
        
        // given/when
        let sut = makeSUT()
        // then
        let timeDurationLabel = try sut.inspect().find(viewWithAccessibilityIdentifier: "time_duration_label").text().string()
        XCTAssertEqual(timeDurationLabel, "00:00:00")
    }



    // nonfunctional - too much time to set up mock timer, leaving as documentation
    func test_stopwatchHHmmssView_updateViewWhenTimerFires_delivers00Hours00Minutes01Seconds() {

        // given - any date as the startDate
        let date = Date(timeIntervalSince1970: 1689716130)
        let sut = makeSUT(startDate: date)
        
        // when - the timer published event is received by the sut
        // then - the display will show one second later "00:00:01"
    }
    
    
    // MARK: - Helpers
    func makeSUT(startDate: Date = Date()) -> StopwatchHHmmssView {
        
        StopwatchHHmmssView(startDate: startDate)
    }
}
