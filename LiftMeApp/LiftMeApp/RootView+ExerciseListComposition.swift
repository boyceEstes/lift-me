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
    func makeExerciseListView() -> some View {
        
        let viewModel = ExercisesViewModel(
            routineStore: routineStore,
            goToExerciseDetailView: goToExerciseDetail,
            goToCreateExerciseView: goToCreateExercise
        )
        
        ExercisesView(viewModel: viewModel)
    }
}
