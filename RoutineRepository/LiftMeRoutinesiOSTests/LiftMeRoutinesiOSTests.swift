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

struct RoutineListView: View {
    
    var body: some View {
        Text("Hello world")
    }
}

/*
 * - Init of view will request no routines
 * - Appear will request load once
 * - Failure to load will display failure message
 *
 */


class LiftMeRoutinesiOSTests: XCTestCase {

    func test_routineListView_init_doesNotRequestRoutineRepository() {
        
        let (_, routineRepository) = makeSUT()
        
        XCTAssertTrue(routineRepository.requests.isEmpty)
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RoutineListView, RoutineRepositorySpy) {
        
        let routineRepository = RoutineRepositorySpy()
        let sut = RoutineListView()
        trackForMemoryLeaks(routineRepository)
        
        return (sut, routineRepository)
    }
}


class RoutineRepositorySpy: RoutineRepository {
    
    enum ReceivedMessage: Equatable {
        case save(Routine)
        case loadAllRoutines
    }
    
    private(set) var requests = [ReceivedMessage]()
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {
        requests.append(.save(routine))
    }
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        requests.append(.loadAllRoutines)
    }
}
