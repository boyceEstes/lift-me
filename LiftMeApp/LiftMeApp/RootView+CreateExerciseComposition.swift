//
//  RootView+CreateExerciseComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//


import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    @ViewBuilder
    func makeCreateExerciseViewWithStackNavigation(
        createExerciseCompletion: @escaping (Exercise) -> Void
    ) -> some View {
        
        NavigationStack {
            makeCreateExerciseView(createExerciseCompletion: createExerciseCompletion)
        }
    }
    
    
    @ViewBuilder
    private func makeCreateExerciseView(
        createExerciseCompletion: @escaping (Exercise) -> Void
    ) -> some View {
        
        let viewModel = CreateExerciseViewModel(
            routineStore: routineStore,
            createExerciseCompletion: createExerciseCompletion
        )
        
        CreateExerciseView(viewModel: viewModel)
    }
}
