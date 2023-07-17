//
//  HomeViewTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/11/23.
//

import XCTest
import ViewInspector
import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS
@testable import LiftMeApp




final class HomeViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HomeView {
        
        let routineStore = RoutineStoreSpy()
        let routineListView = RoutineListView(routineStore: routineStore, goToCreateRoutine: { }, goToRoutineDetail: { _ in })
        let sut = HomeView(routineListView: routineListView, goToWorkoutViewWithNoRoutine: { })
        
//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut)
    }
}
