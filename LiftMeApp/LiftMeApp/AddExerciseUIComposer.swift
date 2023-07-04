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
    
    
    typealias AddExerciseViewWithNavigation = StackNavigationView<SheetyNavigationView<AddExerciseView, AddExerciseNavigationFlow>, AddExerciseNavigationFlow>
    
    func makeAddExerciseViewWithNavigation(
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        dismiss: @escaping () -> Void
    ) -> AddExerciseViewWithNavigation {
        
        let addExerciseView = makeAddExerciseView(
            addExerciseCompletion: addExerciseCompletion,
            dismiss: dismiss
        )
        
        let sheetyNavigationView = SheetyNavigationView(sheetyNavigationViewModel: navigationFlow, content: addExerciseView)
        return StackNavigationView(stackNavigationViewModel: navigationFlow, content: sheetyNavigationView)
    }
    
    
    func makeAddExerciseView(
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        dismiss: @escaping () -> Void
    ) -> AddExerciseView {
        
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExerciseCompletion,
            goToCreateExercise: { handleCreateExerciseCompletion in
                print("Trigger go to create exercise")
                self.navigationFlow.modallyDisplayedView = .createExercise(
                    dismiss: { exercise in
                        
                        print("dismissing create exercise")
                        self.navigationFlow.modallyDisplayedView = nil
                        handleCreateExerciseCompletion(exercise)
                }, UUID())
            }
        )
        return AddExerciseView(viewModel: viewModel)
    }
}
