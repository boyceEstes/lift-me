//
//  LiftMeRoutinesiOSTests.swift
//  LiftMeRoutinesiOSTests
//
//  Created by Boyce Estes on 10/18/22.
//

import XCTest
import LiftMeRoutinesiOS
import RoutineRepository
import SwiftUI
import ViewInspector


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
    var didAppear: ((Self) -> Void)?
    
    var body: some View {
        Text("Hello world")
            .onAppear {
                viewModel.loadRoutines()
                self.didAppear?(self)
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
        
        var (sut, routineRepository) = makeSUT()
        
        let exp = expectation(description: "Wait for RoutineListView to appear")
        
        sut.didAppear = { _ in
            
            XCTAssertEqual(routineRepository.requests, [.loadAllRoutines])
            exp.fulfill()
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
