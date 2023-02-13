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
    func makeWorkoutViewWithSheetyNavigation(routine: Routine?, dismiss: @escaping () -> Void) -> SheetyNavigationView<WorkoutView, WorkoutNavigationFlow> {
        
        let workoutView = makeWorkoutView(routine: routine, dismiss: dismiss)
        
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: workoutView
        )
    }
    
    
    func makeWorkoutView(routine: Routine?, dismiss: @escaping () -> Void) -> WorkoutView {
        
        let viewModel = WorkoutViewModel(
            routineStore: routineStore,
            routine: routine,
            goToCreateRoutineView: { routineRecord in
                self.navigationFlow.modallyDisplayedView = .createRoutineView(
                    routineRecord: routineRecord,
                    superDismiss: dismiss
                )
            },
            dismiss: dismiss
        )
        
        return WorkoutView(
            viewModel: viewModel,
            goToAddExercise: {
                self.navigationFlow.modallyDisplayedView = .addExercise(
                    addExercisesCompletion: viewModel.addExercisesCompletion,
                    dismiss: { [weak self] in
                        self?.navigationFlow.dismiss()
                    }
                )
            }
        )
    }
    
    
    func makeAddExerciseView(
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        dismiss: @escaping () -> Void
    ) -> AddExerciseView {
        
        // what if I just post a notification and observe it in the workout view?
        // can I post with a routine record and an array of exercises?
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExerciseCompletion,
            dismiss: dismiss
        )
        return AddExerciseView(viewModel: viewModel)
    }
    
    
    // super dismiss will dismiss from home composer (thus clearing out the entire workout modal)
    // dismiss will just dismiss from the workout composer (thus going back to the original workout view)
    func makeCreateRoutineView(
        routineRecord: RoutineRecord,
        superDismiss: @escaping () -> Void
    ) -> CreateRoutineView {

        let viewModel = CreateRoutineViewModel(
            routineStore: routineStore,
            routineRecord: routineRecord,
            dismiss: { [weak self] in
                print("workout view dismiss")
                self?.navigationFlow.dismiss()
            },
            superDismiss: superDismiss
        )
        
        return CreateRoutineView(viewModel: viewModel)
    }
}
