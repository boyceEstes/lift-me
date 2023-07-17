//
//  RootView+RoutineDetailComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    @ViewBuilder
    func makeRoutineDetailViewWithSheetNavigation(
        routine: Routine
    ) -> some View {
        
        makeRoutineDetailView(routine: routine)
            .sheet(item: $routineDetailNavigationFlowDisplayedSheet) { identifier in
                switch identifier {
                    
                case let .addExercise(addExerciseCompletion):
                    makeAddExerciseViewWithStackSheetNavigation(addExercisesCompletion: addExerciseCompletion)
                case let .workout(routine):
                    workoutViewWithStackSheetNavigation(routine: routine)
                }
            }
    }
    
    
    @ViewBuilder
    func makeRoutineDetailView(
        routine: Routine
    ) -> some View {
        
        RoutineDetailView(
            routineStore: routineStore,
            routine: routine,
            goToAddExerciseFromRoutineDetail: goToAddExerciseFromRoutineDetail,
            goToWorkout: goToWorkoutFromRoutineDetail,
            goToExerciseDetail: goToExerciseDetailFromRoutineDetail
        )
    }
    
    
    // MARK: - Navigation
    func goToAddExerciseFromRoutineDetail(addExerciseCompletion: @escaping ([Exercise]) -> Void) {
        routineDetailNavigationFlowDisplayedSheet = .addExercise(addExerciseCompletion)
    }
    
    
    func goToWorkoutFromRoutineDetail(routine: Routine) {
        routineDetailNavigationFlowDisplayedSheet = .workout(routine)
    }
    
    
    // NOTE: This is going to be pushed from the HomeNavigationFlow path. If it ever needs it own modal, give it its
    // own navigation stack
    func goToExerciseDetailFromRoutineDetail(exercise: Exercise) {
        homeNavigationFlowPath.append(.exerciseDetail(exercise: exercise))
    }
}
