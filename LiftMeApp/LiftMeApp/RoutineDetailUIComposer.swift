//
//  RoutineDetailUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/11/23.
//

import RoutineRepository
import LiftMeRoutinesiOS
import SwiftUI


enum RoutineDetailUIComposer {
    
    @ViewBuilder
    static func makeRoutineDetailView(
        routineStore: RoutineStore,
        routine: Routine,
        goToAddExerciseFromRoutineDetail: @escaping (@escaping ([Exercise]) -> Void) -> Void
    ) -> RoutineDetailView {
        
//        let viewModel = RoutineDetailViewModel(routineStore: routineStore, routine: routine, goToAddExercise: goToAddExerciseFromRoutineDetail)
        RoutineDetailView(
            routineStore: routineStore,
            routine: routine,
            goToAddExerciseFromRoutineDetail: goToAddExerciseFromRoutineDetail
        )
    }
}
