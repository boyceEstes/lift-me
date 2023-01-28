//
//  AddExerciseViewUIIntegrationTests.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/20/23.
//

import XCTest
import ViewInspector
import SwiftUI
import LiftMeRoutinesiOS
@testable import LiftMeApp

extension AddExerciseView: Inspectable { }
extension BasicExerciseRowView: Inspectable { }


final class AddExerciseViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_addExerciseView_init_doesNotRequestAllExerciseLoad() {
        
        // given/when
        let (_, routineStore, _) = makeSUT()
        
        // then
        XCTAssertTrue(routineStore.requests.isEmpty)
    }
    
    
    func test_addExerciseView_viewWillAppear_requestsAllExerciseLoad() {
        
        // given
        let (sut, routineStore, _) = makeSUT()
        
        let exp = sut.inspection.inspect { view in
            // then
            XCTAssertEqual(routineStore.requests, [.loadAllExercises])
        }
        
        // when
        ViewHosting.host(view: sut)

        wait(for: [exp], timeout: 1)
    }
    

    func test_addExerciseView_readAllExercisesCompletionWithExercises_willRenderExercises() throws {

        // given
        let (sut, routineStore, _) = makeSUT()
        let exercises = [uniqueExercise(), uniqueExercise(), uniqueExercise()]

        let exp = sut.inspection.inspect { sut in

//            sut.findAll(BasicExerciseRowView.self)
            let exerciseRowsBeforeRead = sut.findAll(BasicExerciseRowView.self)
            XCTAssertTrue(exerciseRowsBeforeRead.isEmpty)

            // when 2
            routineStore.completeReadAllExercises(with: exercises)

            let exerciseRowsAfterRead = sut.findAll(BasicExerciseRowView.self)
            XCTAssertEqual(exerciseRowsAfterRead.count, exercises.count)
        }

        // when 1
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 1)
    }
    
    
    

    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: AddExerciseView, routineStore: RoutineStoreSpy, navigationFlow: WorkoutNavigationFlow) {

        let workoutUIComposer = WorkoutUIComposerWithSpys()
        let workoutNavigationFlow = workoutUIComposer.navigationFlow
        let sut = workoutUIComposer.makeAddExerciseView()
        let routineStore: RoutineStoreSpy = workoutUIComposer.routineStore as! RoutineStoreSpy

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineStore, workoutNavigationFlow)
    }
}
