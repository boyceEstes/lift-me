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


final class AddExerciseViewUIIntegrationTests: XCTestCase {

    func test_viewInspector_baseLine_succeeds() throws {
        
        let expected = "It lives!"
        let sut = Text(expected)
        let value = try sut.inspect().text().string()
        XCTAssertEqual(value, expected)
    }
    
    
    func test_addExerciseView_init_rendersAddExerciseButton() {
        
        // given/when
        let (sut, _) = makeSUT()
        
        // then
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "add-selected-exercises"))
    }
    
    
    func test_addExerciseView_viewWillAppear_requestsAllExerciseLoad() {
        
        // given
        let (sut, routineStore) = makeSUT()
        
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
        let (sut, routineStore) = makeSUT()
        let exercises = [uniqueExercise(), uniqueExercise(), uniqueExercise()]

        // when/then
        assertThatRoutineStoreRendersGivenExercises(in: sut, routineStore: routineStore, with: exercises)
    }
    
    
    func test_addExerciseView_filterExerisesByString_rendersOnlyMatchingExercises() {
        
        let (sut, routineStore) = makeSUT()
        
        let exercises = [
            uniqueExercise(name: "Bench"),
            uniqueExercise(name: "Deadlift"),
            uniqueExercise(name: "Squat")]
        let expectedNumberOfFilteredExercises = 1

        assertThatRoutineStoreRendersGivenExercises(in: sut, routineStore: routineStore, with: exercises)
        
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
        
        let (sut, routineStore) = makeSUT()
        
        let expectedExercises = [
            uniqueExercise(name: "Bench"),
            uniqueExercise(name: "Deadlift"),
            uniqueExercise(name: "Squat")
        ]

//        assertThatRoutineStoreRendersGivenExercises(in: sut, routineStore: routineStore, with: exercises)
        
        // Ensure that exercises are loaded and filtered exercise will render
        let exp = sut.inspection.inspect { sut in
            
            // given - Ensure that exercises are loaded and filtered exercise rows render
            let exerciseRowsBeforeRead = self.findAllWhereParentViewHas(accessibilityIdentifier: "filtered_exercise_list", for: sut)
            XCTAssertTrue(exerciseRowsBeforeRead.isEmpty)
            
            // when - Stub loading some test exercises
            routineStore.completeReadAllExercises(with: expectedExercises)
            
            // then - Find all rows rendered now that stub exercises were loaded
            let exerciseRowsAfterRead = self.findAllWhereParentViewHas(accessibilityIdentifier: "filtered_exercise_list", for: sut)
            XCTAssertEqual(exerciseRowsAfterRead.count, expectedExercises.count)
        }

        
        // Ensure that exercises loaded will be added to the selected list when tapped
        let exp2 = sut.inspection.inspect { sut in
            
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
        }
        
        
        // Ensure that a selected exercise can be deselected when tapped in selected list
        let exp3 = sut.inspection.inspect { sut in
            
            // given -
            let selectedExerciseList = try sut.find(SelectedExercisesList.self)
            let selectedExerciseRows = selectedExerciseList.findAll(SelectableBasicExerciseRowView.self)
            let selectedExerciseBenchRow = try selectedExerciseList.find(SelectableBasicExerciseRowView.self, containing: "Bench")
            
            XCTAssertEqual(selectedExerciseRows.count, 2)
            
            // when - selected exercise in selected exercise list is tapped
            try selectedExerciseBenchRow.button().tap()
            
            // then - tapped exercise is deselected and removed from the selected list
            let selectedExerciseRowsAfter = selectedExerciseList.findAll(SelectableBasicExerciseRowView.self)

            XCTAssertEqual(selectedExerciseRowsAfter.count, 1)
        }
        
        
        // Ensure that a selected exercise can be deselected when tappend in filtered list
        let exp4 = sut.inspection.inspect { sut in
            
            // given - filtered exercise with an exercise selected
            let filteredSelectableList = try sut.find(FilteredAllExercisesList.self)
            let selectedInFilteredExerciseCount = filteredSelectableList.findAll(SelectableBasicExerciseRowView.self, where: { view in
                try view.actualView().selectableExercise.isSelected == true
            }).count
            
            let selectedExerciseDeadliftRow = try filteredSelectableList.find(SelectableBasicExerciseRowView.self, containing: "Deadlift")
            
            XCTAssertEqual(selectedInFilteredExerciseCount, 1) // Should only be Deadlift exercise at this point
            
            // when - selected exercise is tapped in filtered exercise list is tapped
            try selectedExerciseDeadliftRow.button().tap()
            
            // then - no more selected exercises
            let selectedInFilteredExerciseCountAfter = filteredSelectableList.findAll(SelectableBasicExerciseRowView.self, where: { view in
                try view.actualView().selectableExercise.isSelected == true
            }).count
            XCTAssertEqual(selectedInFilteredExerciseCountAfter, 0)
            
            // and - still all three exercises exist in filtered list, just unselected
            let unselectedInFilteredExerciseCount = filteredSelectableList.findAll(SelectableBasicExerciseRowView.self, where: { view in
                try view.actualView().selectableExercise.isSelected == false
            }).count
            XCTAssertEqual(unselectedInFilteredExerciseCount, 3)
        }
        

        ViewHosting.host(view: sut)
        wait(for: [exp, exp2, exp3, exp4], timeout: 1)
    }
    
    
//    func test_addExerciseView_swipeToDeleteOnFilteredExercise_deletesAnExercise() {
//
//        // given
//        let (sut, routineStore) = makeSUT()
//
//        let exercises = [
//            uniqueExercise(name: "Bench"),
//            uniqueExercise(name: "Deadlift"),
//            uniqueExercise(name: "Squat")]
//
//        let exerciseToDeleteIndex = 0
//        let exerciseToDelete = exercises[exerciseToDeleteIndex]
//
//        assertThatRoutineStoreRendersGivenExercises(in: sut, routineStore: routineStore, with: exercises)
//
//        let exp = sut.inspection.inspect { sut in
//
//            let filteredSelectableList = try sut.find(FilteredAllExercisesList.self)
//            let allFilteredSelectableExerciseRowsBeforeDeletion = filteredSelectableList.findAll(SelectableBasicExerciseRowView.self)
//
//            XCTAssertEqual(allFilteredSelectableExerciseRowsBeforeDeletion.count, 3)
//
//            // when
//            try filteredSelectableList.list().forEach(0).callOnDelete(IndexSet(integer: exerciseToDeleteIndex))
//
//            // then
//            let allFilteredSelectableExerciseRowsAfterDeletion = filteredSelectableList.findAll(SelectableBasicExerciseRowView.self)
//
//            // This test does not work when we are relying on the datasource completely and not doing a
//            // `selectableFilteredExercises.remove(atOffsets: offsets)`
//            //
//            // This doesn't work because we use a fake data source in this unit testing.
//            // The best we can do is just make sure that the correct method to delete is called.
//
//            XCTAssertEqual(routineStore.requests, [.getExerciseDataSource, .deleteExercise(exerciseToDelete.id)])
//        }
//
//        ViewHosting.host(view: sut)
//        wait(for: [exp], timeout: 1)
//    }
    
    
    func test_addExerciseView_openCreateExerciseAndSaveExercise_willSelectTheExerciseInTheList() {
        // This also seems hard to test with the data source spy instead of the actual data source because we are needing the list to be repopulated with the new row.
    }
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (view: AddExerciseView, routineStore: RoutineStoreSpy) {

        let routineStore = RoutineStoreSpy()
        let sut = AddExerciseView(
            routineStore: routineStore,
            addExerciseCompletion: { _ in },
            goToCreateExercise: { _ in }
        )
        return (sut, routineStore)
    }
    
    
    private func assertThatRoutineStoreRendersGivenExercises(
        in sut: AddExerciseView,
        routineStore: RoutineStoreSpy,
        with expectedExercises: [Exercise],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        
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
