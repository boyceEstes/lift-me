//
//  WorkoutUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS
//import NavigationFlow

typealias AddExercisesCompletion = ([Exercise]) -> Void

public class WorkoutUIComposer {
    
    static func makeWorkoutView(
        routineStore: RoutineStore,
        routine: Routine?,
        goToCreateRoutine: @escaping (RoutineRecord) -> Void,
        goToAddExercise: @escaping (@escaping AddExercisesCompletion) -> Void
    ) -> WorkoutView {
        
        let viewModel = WorkoutViewModel(
            routineStore: routineStore,
            routine: routine,
            goToAddExercise: {
                let tempWorkoutViewModel = WorkoutViewModel(routineStore: routineStore, goToAddExercise: {}, goToCreateRoutineView: { _ in })
                goToAddExercise(tempWorkoutViewModel.addExercisesCompletion)
            },
            goToCreateRoutineView: goToCreateRoutine
        )
        
        return WorkoutView(viewModel: viewModel)
    }
    
//    let routineStore: RoutineStore
//    let createRoutineUIComposer: CreateRoutineUIComposer
//    let addExerciseUIComposer: AddExerciseUIComposer
//    let exerciseUIComposer: ExerciseUIComposer
//
//    lazy var navigationFlow: WorkoutNavigationFlow = { [unowned self] in
//        return WorkoutNavigationFlow(
//            workoutUIComposer: self,
//            createRoutineUIComposer: createRoutineUIComposer,
//            addExerciseUIComposer: addExerciseUIComposer,
//            exerciseUIComposer: exerciseUIComposer
//        )
//    }()
//
    
//    init(routineStore: RoutineStore,
//         createRoutineUIComposer: CreateRoutineUIComposer,
//         addExerciseUIComposer: AddExerciseUIComposer,
//         exerciseUIComposer: ExerciseUIComposer
//    ) {
//
//        self.routineStore = routineStore
//        self.createRoutineUIComposer = createRoutineUIComposer
//        self.addExerciseUIComposer = addExerciseUIComposer
//        self.exerciseUIComposer = exerciseUIComposer
//    }

    // WorkoutNavigationFlow for the workout since I want it to stay up whne it presents its own sheet
//    typealias WorkoutViewWithNavigation = StackNavigationView<SheetyNavigationView<WorkoutView, WorkoutNavigationFlow>, WorkoutNavigationFlow>
//
//    func makeWorkoutViewWithNavigation(
//        routine: Routine?,
//        dismiss: @escaping () -> Void
//    ) -> WorkoutViewWithNavigation {
//
//        let workoutView = makeWorkoutView(routine: routine, dismiss: dismiss)
//
//        let sheetyNavigationView = SheetyNavigationView(
//            sheetyNavigationViewModel: navigationFlow,
//            content: workoutView
//        )
//
//        return StackNavigationView(
//            stackNavigationViewModel: navigationFlow,
//            content: sheetyNavigationView
//        )
//    }
//
//
//    func makeWorkoutView(routine: Routine?, dismiss: @escaping () -> Void) -> WorkoutView {
//
//        let viewModel = WorkoutViewModel(
//            routineStore: routineStore,
//            routine: routine,
//            goToCreateRoutineView: { [weak self] routineRecord in
//
//                self?.navigationFlow.modallyDisplayedView = .createRoutineView(
//                    routineRecord: routineRecord,
//                    superDismiss: {
//                        print("super dismiss called")
//                        // dismiss view from the workout navigation flow
//                        self?.navigationFlow.modallyDisplayedView = nil
//                        // dismiss view from the home navigation flow
//                        dismiss()
//                    }
//                )
//            },
//            dismiss: dismiss
//        )
//
//        return WorkoutView(
//            viewModel: viewModel,
//            goToAddExercise: {
//                self.navigationFlow.modallyDisplayedView = .addExercise(
//                    addExercisesCompletion: viewModel.addExercisesCompletion,
//                    dismiss: { [weak self] in
//                        self?.navigationFlow.dismiss()
//                    }
//                )
//            }
//        )
//    }
}
