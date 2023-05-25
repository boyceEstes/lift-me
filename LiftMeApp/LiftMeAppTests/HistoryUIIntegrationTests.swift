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
extension RoutineRecordCellView: Inspectable { }

final class HistoryUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_historyView_viewAppears_willRequestRoutineRecordsFromRoutineStore() {
        
        // GIVEN
        let (sut, routineStore, _) = makeSUT()
        
        let exp = sut.inspection.inspect { sut in
            
            // THEN
            // assert that the routine store has been requested for .readAllRoutineRecords
            XCTAssertEqual(routineStore.requests, [.readAllRoutineRecords])
        }
        
        // WHEN
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_historyView_readRoutineRecordsWithNonEmptyCache_rendersRowsForEachRoutineRecordSaved() {
        
        // GIVEN
        let (sut, routineStore, _) = makeSUT()
        
        let exercise = uniqueExercise()
        let routineRecords = [uniqueRoutineRecord(exercise: exercise), uniqueRoutineRecord(exercise: exercise)]
        
        let exp = sut.inspection.inspect { sut in
            
            let cellsBeforeRoutineRecordLoad = sut.findAll(RoutineRecordCellView.self)
            XCTAssertEqual(cellsBeforeRoutineRecordLoad.count, 0)
            
            // WHEN
            // load the routine records
            routineStore.completeReadRoutineRecords(with: routineRecords)
            
            // THEN
            let cellsAfterRoutineRecordLoad = sut.findAll(RoutineRecordCellView.self)
            XCTAssertEqual(cellsAfterRoutineRecordLoad.count, 2)
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    // TODO:
    //    func test_historyView_readRoutineRecordsWithEmptyCache_rendersNoRowsForRoutineRecord() {
    //
    //    }
    
    
    // TODO:
    //    func test_historyView_readRoutineRecordsWithError_rendersError() {
    //
    //    }
    
    
    // TODO:
    //    func test_historyView_routineRecordCellViewTapped_callsGoToRoutineRecordDetailView() {
    //    }
    
    
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
