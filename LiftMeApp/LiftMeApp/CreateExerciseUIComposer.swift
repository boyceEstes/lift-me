//
//  CreateExerciseUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/9/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS



class CreateExerciseUIComposer {
    
    @ViewBuilder
    static func makeCreateExerciseView(
        routineStore: RoutineStore,
        createExerciseCompletion: @escaping (Exercise) -> Void
    ) -> CreateExerciseView {
        
        let viewModel = CreateExerciseViewModel(
            routineStore: routineStore,
            createExerciseCompletion: createExerciseCompletion
        )
        
        CreateExerciseView(viewModel: viewModel)
    }
}
