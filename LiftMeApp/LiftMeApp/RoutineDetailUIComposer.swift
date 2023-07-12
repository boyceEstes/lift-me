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
        goToAddExerciseFromRoutineDetail: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToWorkout: @escaping (Routine) -> Void
    ) -> RoutineDetailView {
        
        RoutineDetailView(
            routineStore: routineStore,
            routine: routine,
            goToAddExerciseFromRoutineDetail: goToAddExerciseFromRoutineDetail,
            goToWorkout: goToWorkout
        )
    }
}
