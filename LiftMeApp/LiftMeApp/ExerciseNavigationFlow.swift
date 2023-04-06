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


class ExerciseNavigationFlow: SheetyStackNavigationFlow {
    
    enum StackIdentifier: Hashable {
        case exerciseListView
        case exerciseDetailView(exercise: Exercise)
    }
    
    
    enum SheetyIdentifier: Identifiable {
        
        var id: Int { self.hashValue }
        
        case createExerciseView
    }
    
    
    weak var exerciseUIComposer: ExerciseUIComposer?
    
    
    @Published var path = [StackIdentifier]()
    @Published var modallyDisplayedView: SheetyIdentifier? = nil
    
    
    init(exerciseUIComposer: ExerciseUIComposer?) {
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    
    func pushToStack(_ identifier: StackIdentifier) -> some View {

        return Group {
            switch identifier {
            case .exerciseListView:
                exerciseUIComposer?.makeExercisesViewWithSheetyStackNavigation()

            case let .exerciseDetailView(exercise):
                exerciseUIComposer?.makeExerciseDetailViewWithStackNavigation(exercise: exercise)
            }
        }
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        switch identifier {
        case .createExerciseView: return exerciseUIComposer?.makeCreateExerciseViewWithStackNavigation()
        }
    }
}

