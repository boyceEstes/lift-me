//
//  WorkoutUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS
import NavigationFlow


public class WorkoutUIComposer {
    
    let routineStore: RoutineStore
    
    lazy var navigationFlow: WorkoutNavigationFlow = { [unowned self] in
        return WorkoutNavigationFlow(workoutUIComposer: self)
    }()
    
    
    init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }

    // WorkoutNavigationFlow for the workout since I want it to stay up whne it presents its own sheet
    func makeWorkoutViewWithSheetyNavigation() -> SheetyNavigationView<WorkoutView, WorkoutNavigationFlow> {
        
        let workoutView = makeWorkoutView()
        
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: workoutView
        )
    }
    
    
    func makeWorkoutView() -> WorkoutView {
        
        let viewModel = WorkoutViewModel(routineStore: routineStore)
        return WorkoutView(
            viewModel: viewModel,
            goToAddExercise: {
                self.navigationFlow.modallyDisplayedView = .addExercise(
                    addExercisesCompletion: viewModel.addExercisesCompletion
                )
            }
        )
    }
    
    
    func makeAddExerciseView(addExerciseCompletion: @escaping ([Exercise]) -> Void) -> AddExerciseView {
        
        // what if I just post a notification and observe it in the workout view?
        // can I post with a routine record and an array of exercises?
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExerciseCompletion)
        return AddExerciseView(viewModel: viewModel)
    }
}
