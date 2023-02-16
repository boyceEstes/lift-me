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
    let createRoutineUIComposer: CreateRoutineUIComposer
    
    lazy var navigationFlow: WorkoutNavigationFlow = { [unowned self] in
        return WorkoutNavigationFlow(
            workoutUIComposer: self,
            createRoutineUIComposer: createRoutineUIComposer
        )
    }()
    
    
    init(routineStore: RoutineStore, createRoutineUIComposer: CreateRoutineUIComposer) {
        
        self.routineStore = routineStore
        self.createRoutineUIComposer = createRoutineUIComposer
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
        
        let viewModel = AddExerciseViewModel(
            routineStore: routineStore,
            addExerciseCompletion: addExerciseCompletion,
            dismiss: dismiss
        )
        return AddExerciseView(viewModel: viewModel)
    }
    
}
