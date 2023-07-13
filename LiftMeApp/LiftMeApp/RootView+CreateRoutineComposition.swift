//
//  RootView+CreateRoutineComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    
    func makeCreateRoutineViewWithStackSheetNavigation(
        routineRecord: RoutineRecord?,
        superDismiss: (() -> Void)?
    ) -> some View {
        
        NavigationStack(path: $createRoutineNavigationFlowPath) {
            makeCreateRoutineViewWithSheetNavigation(
                routineRecord: routineRecord,
                superDismiss: superDismiss
            )
            .navigationDestination(for: CreateRoutineNavigationFlow.StackIdentifier.self) { identifier in
                switch identifier {
                case let .exerciseDetail(exercise):
                    exerciseDetailView(exercise: exercise)
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func makeCreateRoutineViewWithSheetNavigation(
        routineRecord: RoutineRecord?,
        superDismiss: (() -> Void)?
    ) -> some View {
        
        makeCreateRoutineView(
            routineRecord: routineRecord,
            superDismiss: superDismiss
        )
        .sheet(item: $createRoutineNavigationFlowDisplayedSheet) { identifier in
            switch identifier {
            case let .addExercise(addExercisesCompletion):
                addExerciseViewWithNavigation(addExercisesCompletion: addExercisesCompletion)
            }
        }
    }
    
    
    @ViewBuilder
    private func makeCreateRoutineView(
        routineRecord: RoutineRecord?,
        superDismiss: (() -> Void)?
    ) -> some View {
        
        CreateRoutineView(
            routineStore: routineStore,
            routineRecord: routineRecord,
            superDismiss: superDismiss,
            goToAddExercise: goToAddExerciseFromCreateRoutine,
            goToExerciseDetail: goToExerciseDetailFromCreateRoutine
        )
    }
    
    
    // MARK: - Navigation
    func goToAddExerciseFromCreateRoutine(addExerciseCompletion: @escaping AddExercisesCompletion) {
        createRoutineNavigationFlowDisplayedSheet = .addExercise(addExercisesCompletion: addExerciseCompletion)
    }
    
    
    func goToExerciseDetailFromCreateRoutine(exercise: Exercise) {
        createRoutineNavigationFlowPath.append(.exerciseDetail(exercise))
    }
}
