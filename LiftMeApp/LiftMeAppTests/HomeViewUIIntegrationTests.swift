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



extension HomeView: Inspectable { }

final class HomeViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_homeView_init_displaysTappableCustomRoutineButton() {
        
        let sut = makeSUT().view
        XCTAssertNoThrow(try sut.inspect().find(button: "Custom Routine"))
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: HomeView, routineStore: RoutineStoreSpy, navigationFlow: HomeNavigationFlow) {
        
        let homeUIComposer = HomeUIComposerWithSpys()
        let routineNavigationFlow = homeUIComposer.navigationFlow
        let sut = homeUIComposer.makeHomeView()
        let routineRepository: RoutineStoreSpy = homeUIComposer.routineStore as! RoutineStoreSpy
        
//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineRepository, routineNavigationFlow)
    }
}
