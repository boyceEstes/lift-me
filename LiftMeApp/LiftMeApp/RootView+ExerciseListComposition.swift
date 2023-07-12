//
//  RootView+ExerciseListComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    
    @ViewBuilder
    func makeExerciseListViewWithStackSheetNavigation() -> some View {
        
        makeExerciseListViewWithSheetNavigation()
            .flowNavigationDestination(flowPath: $exerciseListNavigationFlowPath) { identifier in
                switch identifier {
                case let .exerciseDetail(exercise):
                    exerciseDetailView(exercise: exercise)
                }
            }
    }
    
    
    @ViewBuilder
    private func makeExerciseListViewWithSheetNavigation() -> some View {
        
        makeExerciseListView()
            .sheet(item: $exerciseListNavigationFlowDisplayedSheet) { identifier in
                switch identifier {
                case .createExercise:
                    // We do not need any completion logic for the exercise list screen because it is going to
                    // update with a exercises data source.
                    createExerciseViewWithNavigation(createExerciseCompletion: { _ in })
                }
            }
    }
    
    
    @ViewBuilder
    private func makeExerciseListView() -> some View {
        
        ExercisesView(
            routineStore: routineStore,
            goToExerciseDetailView: goToExerciseDetail,
            goToCreateExerciseView: goToCreateExercise
        )
    }
    
    
    // MARK: - Navigation
    
    func goToExerciseDetail(exercise: Exercise) {
        exerciseListNavigationFlowPath.append(.exerciseDetail(exercise))
    }
    
    
    func goToCreateExercise() {
        exerciseListNavigationFlowDisplayedSheet = .createExercise
    }
}
