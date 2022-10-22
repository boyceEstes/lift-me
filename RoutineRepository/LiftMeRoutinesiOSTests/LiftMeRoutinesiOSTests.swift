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
    
    @Published var routines = [Routine]()
    
    init(routineRepository: RoutineRepository) {
        self.routineRepository = routineRepository
    }
    
    
    func loadRoutines() {
        routineRepository.loadAllRoutines { [weak self] result in
            switch result {
            case let .success(routines):
                self?.routines = routines
                
            case let .failure(_):
                break
            }
        }
    }
}


struct RoutineListView: View {
    
    let viewModel: RoutineViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        List(viewModel.routines, id: \.self) { routine in
            RoutineCellView(routine: routine)
        }
            .onAppear {
                viewModel.loadRoutines()
            }
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
    }
}


struct RoutineCellView: View {
    
    let routine: Routine
    
    var body: some View {
        Text("\(routine.name)")
    }
}

/*
 * - Init of view will request no routines
 * - Appear will request load once
 * - ViewInspector works as expected
 * - Appear will render routines
 * - Appear will render empty routines
 * - Failure to load will display failure message
 */

extension RoutineListView: Inspectable {}
extension RoutineCellView: Inspectable {}
extension Inspection: InspectionEmissary {}

class LiftMeRoutinesiOSTests: XCTestCase {
    
    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
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
    
    
    func test_routineListView_successfullyLoadedRoutines_willRenderRoutines() throws {
        
        let routines = [uniqueRoutine().model, uniqueRoutine().model, uniqueRoutine().model, uniqueRoutine().model]
        
        let (sut, routineRepository) = makeSUT()
        
        let exp = sut.inspection.inspect { sut in
            
            let cellsBeforeRoutineLoad = sut.findAll(RoutineCellView.self)
            XCTAssertTrue(cellsBeforeRoutineLoad.isEmpty)
            
            routineRepository.completeRoutineLoading(with: routines)
            
            let cellsAfterRoutineLoad = sut.findAll(RoutineCellView.self)
            XCTAssertEqual(cellsAfterRoutineLoad.count, routines.count)
            
            for (index, routineCellView) in cellsAfterRoutineLoad.enumerated() {
                
                let expectedRoutineName = routines[index].name
                let _ = try routineCellView.find(text: "\(expectedRoutineName)").string()
            }
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
}
