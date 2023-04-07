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
    
    lazy var navigationFlow: AddExerciseNavigationFlow = { [unowned self] in
        AddExerciseNavigationFlow(exerciseUIComposer: exerciseUIComposer)
    }()
    
    
    init(routineStore: RoutineStore,
         exerciseUIComposer: ExerciseUIComposer
    ) {
        self.routineStore = routineStore
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    
    func makeAddExerciseViewWithSheetyNavigation(
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        dismiss: @escaping () -> Void
    ) -> SheetyNavigationView<AddExerciseView, AddExerciseNavigationFlow> {
        
        let addExerciseView = makeAddExerciseView(addExerciseCompletion: addExerciseCompletion, dismiss: dismiss)
        return SheetyNavigationView(sheetyNavigationViewModel: navigationFlow, content: addExerciseView)
    }
    
    
    func makeAddExerciseView(
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        dismiss: @escaping () -> Void
    ) -> AddExerciseView {
        
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExerciseCompletion,
            goToCreateExercise: {
                print("Trigger go to create exercise")
                self.navigationFlow.modallyDisplayedView = .createExercise
            },
            dismiss: dismiss
        )
        return AddExerciseView(viewModel: viewModel)
    }
}
