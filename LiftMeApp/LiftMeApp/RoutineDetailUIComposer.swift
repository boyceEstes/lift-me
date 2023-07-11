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
    static func makeRoutineDetailView(routine: Routine, goToAddExerciseFromRoutineDetail: @escaping (@escaping ([Exercise]) -> Void) -> Void) -> RoutineDetailView {
        
        let viewModel = RoutineDetailViewModel(routine: routine, goToAddExercise: goToAddExerciseFromRoutineDetail)
        RoutineDetailView(viewModel: viewModel)
    }
}
