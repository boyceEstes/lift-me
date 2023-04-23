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
extension SelectedExercisesList: Inspectable { }
extension FilteredAllExercisesList: Inspectable { }
extension SelectableBasicExerciseRowView: Inspectable { }
extension BasicExerciseRowView: Inspectable { }


final class AddExerciseViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_addExerciseView_init_rendersAddExerciseButton() {
        
        // given/when
        let (sut, _, _) = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "add-selected-exercises"))
    }
    
    
    func test_addExerciseView_viewWillAppear_requestsAllExerciseLoad() {
        
        // given
        let (sut, routineStore, _) = makeSUT()
        
        let exp = sut.inspection.inspect { view in
            // then
            XCTAssertEqual(routineStore.requests, [.getExerciseDataSource])
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
            let exerciseRowsAfterFilter = self.findAllWhereParentViewHas(accessibilityIdentifier: "filtered_exercise_list", for: sut)
            XCTAssertEqual(exerciseRowsAfterFilter.count, expectedNumberOfFilteredExercises)
        }

        wait(for: [exp], timeout: 1)
    }
    
    
    func test_addExerciseView_selectExercisesByTappingRows_rendersSelectedExercises() {
        
        let (sut, routineStore, _) = makeSUT()
        
        let exercises = [
            uniqueExercise(name: "Bench"),
            uniqueExercise(name: "Deadlift"),
            uniqueExercise(name: "Squat")]

        assertReadAllExercisesRenders(in: sut, routineStore: routineStore, with: exercises)
        
        let exp = sut.inspection.inspect { sut in
            
            // GIVEN two exercises
            let filteredSelectableList = try sut.find(FilteredAllExercisesList.self)
            let selectableFilteredExercise1 = try filteredSelectableList.find(SelectableBasicExerciseRowView.self, containing: "Bench")
            let selectableFilteredExercise2 = try filteredSelectableList.find(SelectableBasicExerciseRowView.self, containing: "Deadlift")
            
            // WHEN both exercises from filtered exercises list are tapped
            try selectableFilteredExercise1.button().tap()
            try selectableFilteredExercise2.button().tap()
            
            // THEN two exercises are in selected list
            let selectedExerciseListAfterExercisesTapped = try sut.find(SelectedExercisesList.self)
            let selectedExercisesInListAfterExercisesTapped = selectedExerciseListAfterExercisesTapped.findAll(SelectableBasicExerciseRowView.self)
            
            XCTAssertEqual(selectedExercisesInListAfterExercisesTapped.count, 2)
            
            // AND 4 exercises are selected in total (2 exercises in each list)
            XCTAssertEqual(sut.findAll(SelectableBasicExerciseRowView.self, where: { view in
                try view.actualView().selectableExercise.isSelected == true
            }).count, 4)
            
            
            // GIVEN an exercise is selected in the exerciseList
            // WHEN an exercise is deselected from filtered exercise list
            try selectableFilteredExercise1.button().tap()
            // THEN it is removed from the selected exercise list
            let selectedExercisesListAfterDeselectionFromFilteredList = try sut.find(SelectedExercisesList.self)
            let selectedExercisesInListAfterDeselectionFromFilteredList = selectedExercisesListAfterDeselectionFromFilteredList.findAll(SelectableBasicExerciseRowView.self)
            
            XCTAssertEqual(selectedExercisesInListAfterDeselectionFromFilteredList.count, 1)
            
            // AND it is unselected in the filtered exercise list
            XCTAssertEqual(sut.findAll(SelectableBasicExerciseRowView.self, where: { view in
                try view.actualView().selectableExercise.isSelected == true
            }).count, 2)
            
            
            // TODO: Can I consolidate all of these to one List shortcut?
            // GIVEN an exercise is selected
            let selectedExercisesList = try sut.find(SelectedExercisesList.self)
            let selectedExercise = try selectedExercisesList.find(SelectableBasicExerciseRowView.self)

            // WHEN an exercise is deselected from selected exercise list
            try selectedExercise.button().tap()
            
            // THEN it is removed from the selected exercise list
            let selectedExercisesListAfterDeselectionFromSelectedList = try sut.find(SelectedExercisesList.self)
            let selectedExercisesInListAfterDeselectionFromSelectedList = selectedExercisesListAfterDeselectionFromSelectedList.findAll(SelectableBasicExerciseRowView.self)
            
            XCTAssertEqual(selectedExercisesInListAfterDeselectionFromSelectedList.count, 0)
            // AND it is deselected in the filtered exercise list
            XCTAssertEqual(sut.findAll(SelectableBasicExerciseRowView.self, where: { view in
                try view.actualView().selectableExercise.isSelected == true
            }).count, 0)
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: AddExerciseView, routineStore: RoutineStoreSpy, navigationFlow: AddExerciseNavigationFlow) {

        let addExerciseUIComposer = AddExerciseUIComposerWithSpys()
        let addExerciseNavigationFlow = addExerciseUIComposer.navigationFlow
        let sut = addExerciseUIComposer.makeAddExerciseView(
            addExerciseCompletion: { _ in },
            dismiss: addExerciseNavigationFlow.dismiss
        )
        let routineStore: RoutineStoreSpy = addExerciseUIComposer.routineStore as! RoutineStoreSpy

//        trackForMemoryLeaks(routineUIComposer, file: file, line: line)
//        trackForMemoryLeaks(routineNavigationFlow, file: file, line: line)

        return (sut, routineStore, addExerciseNavigationFlow)
    }
    
    
    private func assertReadAllExercisesRenders(
        in sut: AddExerciseView,
        routineStore: RoutineStoreSpy,
        with expectedExercises: [Exercise],
        file: StaticString = #file,
        line: UInt = #line) {
        
        let exp = sut.inspection.inspect { [weak self] sut in
            
            guard let self = self else { return }

            let exerciseRowsBeforeRead = self.findAllWhereParentViewHas(accessibilityIdentifier: "filtered_exercise_list", for: sut)
            XCTAssertTrue(exerciseRowsBeforeRead.isEmpty, file: file, line: line)

            // when 2
            routineStore.completeReadAllExercises(with: expectedExercises)

            let exerciseRowsAfterRead = self.findAllWhereParentViewHas(accessibilityIdentifier: "filtered_exercise_list", for: sut)
            XCTAssertEqual(exerciseRowsAfterRead.count, expectedExercises.count, file: file, line: line)
        }

        // when 1
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 1)
    }
    
    
    private func findAllWhereParentViewHas(accessibilityIdentifier: String, for childView: InspectableView<ViewType.View<AddExerciseView>>) -> [InspectableView<ViewType.ClassifiedView>] {
        
        childView.findAll(where: { view in
            
            return try view.parent().accessibilityIdentifier() == accessibilityIdentifier
        })
    }
}
