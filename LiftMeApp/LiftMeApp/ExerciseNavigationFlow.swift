//
//  ExerciseNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import NavigationFlow
import RoutineRepository
import SwiftUI


class ExerciseNavigationFlow: StackNavigationFlow {
    
    enum StackIdentifier: Hashable {
        case exerciseListView
        case exerciseDetailView(exercise: Exercise)
    }
    
    let exerciseUIComposer: ExerciseUIComposer
    
    @Published var path = [StackIdentifier]()
    
    init(exerciseUIComposer: ExerciseUIComposer) {
        
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    
    func pushToStack(_ identifier: StackIdentifier) -> some View {
        
        return Group {
            switch identifier {
            case .exerciseListView:
                exerciseUIComposer.makeExercisesViewWithStackNavigation()
                
            case let .exerciseDetailView(exercise):
                exerciseUIComposer.makeExerciseDetailViewWithStackNavigation(exercise: exercise)
            }
        }

    }
}
