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


class RoutineViewModel {
    
    let routineRepository: RoutineRepository
    
    
    init(routineRepository: RoutineRepository) {
        self.routineRepository = routineRepository
    }
    
    
    func loadRoutines() {
        routineRepository.loadAllRoutines { result in
            switch result {
            case let .success(routines):
                break
            case let .failure(error):
                break
            }
        }
    }
}


struct RoutineListView: View {
    
    let viewModel: RoutineViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        Text("Hello world")
            .onAppear {
                viewModel.loadRoutines()
            }
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
    }
}

/*
 * - Init of view will request no routines
 * - Appear will request load once
 * - ViewInspector works as expected
 * - Appear will render routine
 * - Failure to load will display failure message
 */

extension RoutineListView: Inspectable {}
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
    
    
    func completeRoutineLoading(with routines: [Routine]) {
        
    }
}
