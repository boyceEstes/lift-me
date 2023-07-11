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



class RoutineDetailNavigationFlow {
    
    enum SheetyIdentifier: Identifiable {
        
        case addExercise(([Exercise]) -> Void)
        case exerciseDetail
        
        var id: String {
            switch self {
            case .addExercise:
                return "AddExercise"
            case .exerciseDetail:
                return "ExerciseDetail"
            }
        }
    }
}
