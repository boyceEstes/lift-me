//
//  RootView+AddExerciseComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    // MARK: Add Exercise Flow
    func makeAddExerciseViewWithStackSheetNavigation(
        addExercisesCompletion: @escaping ([Exercise]) -> Void
    ) -> some View {
        
        NavigationStack {
            makeAddExerciseViewWithSheetNavigation(addExercisesCompletion: addExercisesCompletion)
        }
    }
    
    
    @ViewBuilder
    private func makeAddExerciseViewWithSheetNavigation(
        addExercisesCompletion: @escaping ([Exercise]) -> Void
    ) -> some View {
        
        makeAddExerciseView(addExercisesCompletion: addExercisesCompletion)
            .sheet(item: $addExerciseNavigationFlowDisplayedSheet) { identifier in
                switch identifier {
                case let .createExercise(createExerciseCompletion):
                    createExerciseViewWithNavigation(createExerciseCompletion: createExerciseCompletion)
                }
            }
    }
    
    
    @ViewBuilder
    private func makeAddExerciseView(
        addExercisesCompletion: @escaping ([Exercise]) -> Void
    ) -> some View {
        
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExercisesCompletion,
            goToCreateExercise: goToCreateExerciseFromAddExercise
        )
        
        AddExerciseView(viewModel: viewModel)
    }
    
    
    // MARK: - Navigation
    func goToCreateExerciseFromAddExercise(createExerciseCompletion: @escaping (Exercise) -> Void) {
        addExerciseNavigationFlowDisplayedSheet = .createExercise(createExerciseCompletion: createExerciseCompletion)
    }
}
