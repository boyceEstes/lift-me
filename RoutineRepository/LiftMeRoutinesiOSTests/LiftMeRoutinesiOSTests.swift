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
 * - Failure to load will display failure message
 * // TODO: All Routine Cells will have the same modifier (to make it a roundedRectangle)
 * // - Decided to not test if the button modifiers are applied to the button to create more functional testing than UI testing
 * // TODO: What happens when we have loaded routines successfully once and then fail the second time? We should NOT replace the routines with the error...
 * - Tapping Add new button will Take to the CreateRoutineView
 * -
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
extension Inspection: InspectionEmissary {}

class LiftMeRoutinesiOSTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_routineListView_init_displaysRoutineListTitle() throws {
        
        // given
        let (sut, _) = makeSUT()
        let expectedTitle = "Routines"
        
        // when/then
        let _ = try sut.inspect().find(text: expectedTitle)
    }
    
    
    func test_routineListView_init_displaysNewRoutineButton() throws {
        
        // given
        let (sut, _) = makeSUT()
        let expectedButtonTitle = "New"
        
        // when/then
        let _ = try sut.inspect().find(button: expectedButtonTitle)
    }
    
    
    func test_routineListView_init_displaysMoreRoutinesButton() throws {
        
        // given
        let (sut, _) = makeSUT()
        let expectedButtonTitle = "More"
        
        // when/then
        let _ = try sut.inspect().find(button: expectedButtonTitle)
    }
    

    func test_routineListView_init_doesNotRequestRoutineRepository() {
        
        let (_, routineRepository) = makeSUT()
        
        XCTAssertTrue(routineRepository.requests.isEmpty)
    }
    
    
    func test_routineListView_viewWillAppear_requestsToLoadRoutines() {
        
        let (sut, routineRepository) = makeSUT()
        
        let exp = sut.inspection.inspect { view in
            XCTAssertEqual(routineRepository.requests, [.loadAllRoutines])
        }
        
        ViewHosting.host(view: sut)
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_routineListView_loadRoutineCompletionWithRoutines_willRenderRoutines() throws {
        
        // given
        let (sut, routineRepository) = makeSUT()
        let routines = [uniqueRoutine().model, uniqueRoutine().model, uniqueRoutine().model, uniqueRoutine().model]
        
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
        let (sut, routineRepository) = makeSUT()
        let routines: [Routine] = []
        let expectedNoRoutinesMessage = "Aww shucks. No routines yet."
        
        let exp = sut.inspection.inspect { sut in
            
            // basecase
            let cellsBeforeRoutineLoad = sut.findAll(EmptyRoutineCellView.self)
            XCTAssertTrue(cellsBeforeRoutineLoad.isEmpty)
            
            // when
            routineRepository.completeRoutineLoading(with: routines)
            
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
        let (sut, routineRepository) = makeSUT()
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
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RoutineListView, RoutineRepositorySpy) {
        
        let routineRepository = RoutineRepositorySpy()
        let routineViewModel = RoutineViewModel(routineRepository: routineRepository)
        let sut = RoutineListView(viewModel: routineViewModel)
        
//        trackForMemoryLeaks(routineRepository)
//        trackForMemoryLeaks(routineViewModel)
        
        return (sut, routineRepository)
    }
}


class RoutineRepositorySpy: RoutineRepository {
    
    enum ReceivedMessage: Equatable {
        case save(Routine)
        case loadAllRoutines
    }
    
    private(set) var requests = [ReceivedMessage]()
    private(set) var loadAllRoutinesCompletions = [LoadAllRoutinesCompletion]()
    
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {
        requests.append(.save(routine))
    }
    
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        requests.append(.loadAllRoutines)
        loadAllRoutinesCompletions.append(completion)
    }
    
    
    func completeRoutineLoading(with routines: [Routine], at index: Int = 0) {
        loadAllRoutinesCompletions[index](.success(routines))
    }
    
    
    func completeRoutineLoading(with error: Error, at index: Int = 0) {
        loadAllRoutinesCompletions[index](.failure(error))
    }
}
