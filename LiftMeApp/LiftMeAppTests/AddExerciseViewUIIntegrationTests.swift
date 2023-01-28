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
import RoutineRepository
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

        // when/then
        assertReadAllExercisesRenders(in: sut, routineStore: routineStore, with: exercises)
    }
    
    
    func test_addExerciseView_filterExerisesByString_rendersOnlyMatchingExercises() {
        
        let (sut, routineStore, _) = makeSUT()
        
        let exercises = [
            uniqueExercise(name: "Bench"),
            uniqueExercise(name: "Deadlift"),
            uniqueExercise(name: "Squat")]
        let expectedNumberOfFilteredExercises = 1

        assertReadAllExercisesRenders(in: sut, routineStore: routineStore, with: exercises)
        
        // then
        // Check the items rendered
        
        let exp = sut.inspection.inspect { sut in
            
            // when
            let searchTextField = try sut.find(ViewType.TextField.self)
            try searchTextField.setInput("Bench")
            
            // then
            let exerciseRowsAfterFilter = sut.findAll(BasicExerciseRowView.self)
            XCTAssertEqual(exerciseRowsAfterFilter.count, expectedNumberOfFilteredExercises)
        }

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
    
    
    private func assertReadAllExercisesRenders(
        in sut: AddExerciseView,
        routineStore: RoutineStoreSpy,
        with expectedExercises: [Exercise],
        file: StaticString = #file,
        line: UInt = #line) {
        
        let exp = sut.inspection.inspect { sut in

            let exerciseRowsBeforeRead = sut.findAll(BasicExerciseRowView.self)
            XCTAssertTrue(exerciseRowsBeforeRead.isEmpty, file: file, line: line)

            // when 2
            routineStore.completeReadAllExercises(with: expectedExercises)

            let exerciseRowsAfterRead = sut.findAll(BasicExerciseRowView.self)
            XCTAssertEqual(exerciseRowsAfterRead.count, expectedExercises.count, file: file, line: line)
        }

        // when 1
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 1)
    }
}
