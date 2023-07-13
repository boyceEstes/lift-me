//
//  RootView+ExerciseDetailComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    @ViewBuilder
    func makeExerciseDetailView(exercise: Exercise) -> some View {
        
        let viewModel = ExerciseDetailViewModel(routineStore: routineStore, exercise: exercise)
        ExerciseDetailView(viewModel: viewModel)
    }
}
