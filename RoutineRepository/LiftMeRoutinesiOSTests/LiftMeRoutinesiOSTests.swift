//
//  LiftMeRoutinesiOSTests.swift
//  LiftMeRoutinesiOSTests
//
//  Created by Boyce Estes on 10/18/22.
//

import XCTest
import RoutineRepository
import SwiftUI
import ViewInspector
import Combine


final class Inspection<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks: [UInt: (V) -> Void] = [:]
    
    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}


class RoutineViewModel: ObservableObject {
    
    let routineRepository: RoutineRepository
    
    // TODO: Could I make this a future instead since it should only be emitted once
    @Published var firstLoadCompleted = false
    @Published var routineLoadError = false
    @Published var routines = [Routine]()
    
    init(routineRepository: RoutineRepository) {
        self.routineRepository = routineRepository
    }
    
    
    func loadRoutines() {
        routineRepository.loadAllRoutines { [weak self] result in
            
            if self?.firstLoadCompleted == false {
                self?.firstLoadCompleted = true
            }
            
            switch result {
            case let .success(routines):
                
                self?.routines = routines
                
            case .failure:
                self?.routineLoadError = true
            }
        }
    }
}


struct RoutineListView: View {
    
    let viewModel: RoutineViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 16) {
                    
                    RoutineTitleView()
                    
                    NewRoutineButtonView()
                }
                
                Spacer()

                MoreRoutinesButtonView()
            }
            List {
                if viewModel.firstLoadCompleted {
                    if viewModel.routineLoadError {
                        ErrorRoutineCellView()
                    } else {
                        if viewModel.routines.isEmpty {
                            EmptyRoutineCellView()
                        } else {
                            ForEach(viewModel.routines, id: \.self) { routine in
                                RoutineCellView(routine: routine)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadRoutines()
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}


struct RoutineTitleView: View {
    
    var body: some View {
        Text("Routines")
            .font(.title2)
    }
}


struct NewRoutineButtonView: View {
    
    var body: some View {
        Button {
            print("hello world")
        } label: {
            HStack {
                Text("New")
                Image(systemName: "plus")
            }
        }
    }
}


struct MoreRoutinesButtonView: View {
    
    var body: some View {
        Button {
            print("hello world 2")
        } label: {
            HStack {
                Text("More")
                Image(systemName: "chevron.right")
            }
        }
    }
}


struct RoutineCellView: View {
    
    let routine: Routine
    
    var body: some View {
        Text("\(routine.name)")
    }
}


struct EmptyRoutineCellView: View {
    
    var body: some View {
        Text("Aww shucks. No routines yet.")
    }
}


struct ErrorRoutineCellView: View {
    
    var body: some View {
        Text("Error loading routines... dang")
    }
}



/*
 * // TODO: Add accessibility identifiers
 * - There is a title
 * - There is a new routine button
 * - There is a more button
 * // TODO: Refactor all the above basic components in their own view so we can search for the string in that component. Feels safer in ensuring its existance
 * - Init of view will request no routines
 * - Appear will request load once
 * - ViewInspector works as expected
 * - Appear will render routines
 * - Appear will render empty routines
 * - Failure to load will display failure message
 * // TODO: All Routine Cells will have the same modifier (to make it a roundedRectangle)
 * // TODO: What happens when we have loaded routines successfully once and then fail the second time? We should NOT replace the routines with the error...
 * - Tapping Add new button will Take to the CreateRoutineView
 * -
 */

extension RoutineListView: Inspectable {}
extension RoutineTitleView: Inspectable {}
extension RoutineCellView: Inspectable {}
extension EmptyRoutineCellView: Inspectable {}
extension ErrorRoutineCellView: Inspectable {}
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
