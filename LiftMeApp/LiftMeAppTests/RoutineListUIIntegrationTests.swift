//
//  LiftMeRoutinesiOSTests.swift
//  LiftMeRoutinesiOSTests
//
//  Created by Boyce Estes on 10/18/22.
//

import XCTest
import RoutineRepository
import LiftMeRoutinesiOS
import SwiftUI
import ViewInspector
import NavigationFlow
@testable import LiftMeApp


/*
 * // TODO: Add accessibility identifiers
 * - There is a title
 * - There is a new routine button
 * - There is a more button
 * - Init of view will request no routines
 * - Appear will request load once
 * - ViewInspector works as expected
 * - Appear will render routines
 * - Appear will render empty routines
 * // TODO: Add button tap will add an routine call
 * // TODO: Add button tap will display error if failed to save
 * - Failure to load will display failure message
 * // TODO: All Routine Cells will have the same modifier (to make it a roundedRectangle)
 * // - Decided to not test if the button modifiers are applied to the button to create more functional testing than UI testing
 * // TODO: What happens when we have loaded routines successfully once and then fail the second time? We should NOT replace the routines with the error...
 * - Tapping Add new button will Take to the CreateRoutineView
 * - DispatchQueue.main.async is causing the tests to fail. Gotta figure it out. (Wrap in a DispachQueueMainDecorator
 */


/*
 * A gotcha:
 * Whenever you are testing using ViewInspector, it is not possible to see if the view model is doing live updates or not.
 * To simplify, it is not possible to see if it is an @ObservedObject or just declared in the view.
 * Instead, in the unit tests, it will always behave like it is being live-updated
 */

extension RoutineListView: Inspectable {}
extension RoutineTitleBarView: Inspectable {}
extension MoreRoutinesButtonView: Inspectable {}
extension NewRoutineButtonView: Inspectable {}
extension RoutineTitleView: Inspectable {}
extension RoutineCellView: Inspectable {}
extension EmptyRoutineCellView: Inspectable {}
extension ErrorRoutineCellView: Inspectable {}
extension ScrollableRoutineListView: Inspectable {}
extension StackNavigationView: Inspectable { }

extension Inspection: InspectionEmissary {}

class RoutineListUIIntegrationTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_routineListView_init_displaysRoutineListTitle() throws {
        
        // given
        let (sut, _, _) = makeSUT()
        let expectedTitle = "Routines"
        
        // when/then
        let _ = try sut.inspect().find(text: expectedTitle)
    }
    
    
    func test_routineListView_init_displaysNewRoutineButton() throws {
        
        // given
        let (sut, _, _) = makeSUT()
        let expectedButtonTitle = "New"
        
        // when/then
        let _ = try sut.inspect().find(button: expectedButtonTitle)
    }
    
    
    func test_routineListView_init_displaysMoreRoutinesButton() throws {
        
        // given
        let (sut, _, _) = makeSUT()
        let expectedButtonTitle = "More"
        
        // when/then
        let _ = try sut.inspect().find(button: expectedButtonTitle)
    }
    

    func test_routineListView_init_doesNotRequestRoutineRepository() {
        
        let (_, routineRepository, _) = makeSUT()
        
        XCTAssertTrue(routineRepository.requests.isEmpty)
    }
    
    
    func test_routineListView_viewWillAppear_requestsToLoadRoutines() {
        
        let (sut, routineRepository, _) = makeSUT()
        
        let exp = sut.inspection.inspect { view in
            XCTAssertEqual(routineRepository.requests, [.loadAllRoutines])
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_routineListView_loadRoutineCompletionWithRoutines_willRenderRoutines() throws {
        
        // given
        let (sut, routineRepository, _) = makeSUT()
        let routines = [uniqueRoutine(), uniqueRoutine(), uniqueRoutine(), uniqueRoutine()]
        
        let exp = sut.inspection.inspect { sut in
            
            let cellsBeforeRoutineLoad = sut.findAll(RoutineCellView.self)
            XCTAssertTrue(cellsBeforeRoutineLoad.isEmpty)
            
            routineRepository.completeRoutineLoading(with: routines)
            
            let cellsAfterRoutineLoad = sut.findAll(RoutineCellView.self)
            XCTAssertEqual(cellsAfterRoutineLoad.count, routines.count)
            
            for (index, routineCellView) in cellsAfterRoutineLoad.enumerated() {
                
                let expectedRoutineName = routines[index].name
                let _ = try routineCellView.find(text: "\(expectedRoutineName)")
            }
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_routineListView_loadRoutineCompletionWithoutRoutines_willRenderNoRoutinesMessage() throws {
        
        // given
        let (sut, routineRepository, _) = makeSUT()
        let expectedNoRoutinesMessage = "Aww shucks. No routines yet."
        
        let exp = sut.inspection.inspect { sut in
            
            // basecase
            let cellsBeforeRoutineLoad = sut.findAll(EmptyRoutineCellView.self)
            XCTAssertTrue(cellsBeforeRoutineLoad.isEmpty)
            
            // when
            routineRepository.completeRoutineLoadingWithNoRoutines()
            
            // then
            let cellsAfterRoutineLoad = sut.findAll(EmptyRoutineCellView.self)
            XCTAssertEqual(cellsAfterRoutineLoad.count, 1)
            let _ = try cellsAfterRoutineLoad.first!.find(text: expectedNoRoutinesMessage)
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_routineListView_loadRoutineCompletionWithError_willRenderErrorRoutineCell() throws {
        
        // given
        let (sut, routineRepository, _) = makeSUT()
        let error = anyNSError()
        let expectedRoutineErrorMessage = "Error loading routines... dang"
        
        let exp = sut.inspection.inspect { sut in
            
            // basecase
            let cellsBeforeRoutineLoad = sut.findAll(ErrorRoutineCellView.self)
            XCTAssertTrue(cellsBeforeRoutineLoad.isEmpty)
            
            // when
            routineRepository.completeRoutineLoading(with: error)
            
            // then
            let cellsAfterRoutineLoad = sut.findAll(ErrorRoutineCellView.self)
            XCTAssertEqual(cellsAfterRoutineLoad.count, 1)
            
            let _ = try cellsAfterRoutineLoad.first!.find(text: expectedRoutineErrorMessage)
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
//    TODO: Figure out how to test creating a new routine onto an empty list
//    func test_routineListView_tapNewButton_SavesNewRoutineAndRendersRoutineCell() {
//
//        // given
//        let (sut, routineRepository) = makeSUT()
//
//        // when
//        let exp = sut.inspection.inspect { sut in
//
//            // load comes in on hosting
//            // complete load
//            routineRepository.completeRoutineLoading(with: [])
//
//            let cellsBeforeRoutineSave = sut.findAll(RoutineCellView.self)
//            XCTAssertTrue(cellsBeforeRoutineSave.isEmpty)
//            XCTAssertEqual(routineRepository.requests, [.loadAllRoutines])
//
//            // when
//            try sut.find(button: "New").tap()
//
//            // then
//            // TODO: This should match the routine that is created from the routine view model in the future
//
//            XCTAssertEqual(routineRepository.requests, [.loadAllRoutines, .saveRoutine])
//
//            routineRepository.completeSaveRoutineSuccessfully()
//
//            // to render a new cell, we would need to load again from the updated cache - Ideally we would test this was the same
//            XCTAssertEqual(routineRepository.requests, [.loadAllRoutines, .saveRoutine, .loadAllRoutines])
//            routineRepository.completeRoutineLoading(with: [uniqueRoutine().model], at: 1)
//            let cellsAfterRoutineSaveThenLoad = sut.findAll(RoutineCellView.self)
//            XCTAssertFalse(cellsAfterRoutineSaveThenLoad.isEmpty)
//        }
//
//        ViewHosting.host(view: sut)
//
//        wait(for: [exp], timeout: 1)
//    }
    
    
    func test_routineListView_tapNewButton_navigatesToCreateRoutineView() throws {
        
        // given
        let (sut, _, routineNavigationFlow) = makeSUT()
        let button = try sut.inspect().find(button: "New")
        
        // when
        try button.tap()
        
        // then
        XCTAssertEqual(
            routineNavigationFlow.modallyDisplayedView,
            HomeNavigationFlow.SheetyIdentifier.createRoutine)
    }

    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RoutineListView, RoutineStoreSpy, HomeNavigationFlow) {
        
        let homeUIComposer = HomeUIComposerWithSpys()
        let routineNavigationFlow = homeUIComposer.navigationFlow
        let sut = homeUIComposer.makeRoutineListView().0
        let routineRepository: RoutineStoreSpy = homeUIComposer.routineStore as! RoutineStoreSpy
        
//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineRepository, routineNavigationFlow)
    }
}





extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
