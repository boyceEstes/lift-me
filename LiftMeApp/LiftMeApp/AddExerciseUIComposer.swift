//
//  AddExerciseUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 4/7/23.
//

import Foundation
import RoutineRepository
import NavigationFlow
import LiftMeRoutinesiOS


public class AddExerciseUIComposer {
    
    let routineStore: RoutineStore
    let exerciseUIComposer: ExerciseUIComposer
    
    init(routineStore: RoutineStore,
         exerciseUIComposer: ExerciseUIComposer
    ) {
        self.routineStore = routineStore
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    
    func makeAddExerciseView(
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        dismiss: @escaping () -> Void
    ) -> AddExerciseView {
        
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExerciseCompletion,
            dismiss: dismiss
        )
        return AddExerciseView(viewModel: viewModel)
    }
}
