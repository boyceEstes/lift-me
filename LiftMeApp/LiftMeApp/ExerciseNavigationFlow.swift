//
//  ExerciseNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import NavigationFlow
import SwiftUI


class ExerciseNavigationFlow: StackNavigationFlow {
    
    enum StackIdentifier: Hashable {
        case exerciseListView
    }
    
    let exerciseUIComposer: ExerciseUIComposer
    
    @Published var path = [StackIdentifier]()
    
    init(exerciseUIComposer: ExerciseUIComposer) {
        
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    
    func pushToStack(_ identifier: StackIdentifier) -> some View {
        
        switch identifier {
        case .exerciseListView:
            return exerciseUIComposer.makeExercisesViewWithStackNavigation()
        }
    }
}
