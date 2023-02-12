//
//  HistoryUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 2/12/23.
//

import XCTest
import ViewInspector
import SwiftUI
import LiftMeRoutinesiOS
@testable import LiftMeApp

extension HistoryView: Inspectable { }

final class HistoryUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_historyView_viewAppears_willRequestRoutineRecordsFromRoutineStore() {
        
        let (sut, routineStore, _) = makeSUT()
        
        let exp = sut.inspection.inspect { sut in
            
            // assert that the routine store has been requested for .readAllRoutineRecords
            XCTAssertEqual(routineStore.requests, [.readAllRoutineRecords])
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: HistoryView, routineStore: RoutineStoreSpy, navigationFlow: HistoryNavigationFlow) {

        let historyUIComposer = HistoryUIComposerWithSpys()
        let historyNavigationFlow = historyUIComposer.navigationFlow
        let sut = historyUIComposer.makeHistoryView()
        let routineStore: RoutineStoreSpy = historyUIComposer.routineStore as! RoutineStoreSpy

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineStore, historyNavigationFlow)
    }
}
