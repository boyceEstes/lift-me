//
//  RootView+WorkoutComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    @ViewBuilder
    func workoutViewWithStackSheetNavigation(routine: Routine?) -> some View {
        
        workoutViewWithSheetNavigation(routine: routine)
            .flowNavigationDestination(flowPath: $workoutNavigationFlowPath) { identifier in
                switch identifier {
                case let .exerciseDetails(exercise):
                    makeExerciseDetailView(exercise: exercise)
                }
            }
    }
    
    
    @ViewBuilder
    func workoutViewWithSheetNavigation(routine: Routine?) -> some View {
        
        makeWorkoutView(routine: routine)
            .sheet(item: $workoutNavigationFlowDisplayedSheet) { identifier in
                switch identifier {
                case let .addExercise(addExercisesCompletion):
                    makeAddExerciseViewWithStackSheetNavigation(addExercisesCompletion: addExercisesCompletion)
                    
                case let .createRoutine(routineRecord):
                    makeCreateRoutineViewWithStackSheetNavigation(
                        routineRecord: routineRecord,
                        superDismiss: superDismissWorkoutSheetAndHomeSheet
                    )
                }
            }
    }
    
    
    @ViewBuilder
    func makeWorkoutView(routine: Routine?) -> some View {
        
        WorkoutView(
            routineStore: routineStore,
            routine: routine,
            goToAddExercise: goToAddExerciseFromWorkout,
            goToCreateRoutineView: goToCreateRoutineFromWorkout,
            goToExerciseDetails: goToExerciseDetailsFromWorkout
        )
    }
    
    
    // MARK: - Navigation
    func goToAddExerciseFromWorkout(addExercisesCompletion: @escaping ([Exercise]) -> Void) {
        workoutNavigationFlowDisplayedSheet = .addExercise(addExercisesCompletion: addExercisesCompletion)
    }
    
    
    func goToCreateRoutineFromWorkout(with routineRecord: RoutineRecord) {
        workoutNavigationFlowDisplayedSheet = .createRoutine(routineRecord: routineRecord)
    }
    
    
    func goToExerciseDetailsFromWorkout(for exercise: Exercise) {
        workoutNavigationFlowPath.append(.exerciseDetails(exercise))
    }
    
    
    func superDismissWorkoutSheetAndHomeSheet() {
        
        workoutNavigationFlowDisplayedSheet = nil
        homeNavigationFlowDisplayedSheet = nil
    }
}
