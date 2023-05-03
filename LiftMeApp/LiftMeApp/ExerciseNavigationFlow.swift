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

protocol ExerciseNavigationFlowProtocol: SheetyStackNavigationFlow { }

class ExerciseNavigationFlow: ExerciseNavigationFlowProtocol {
    
    enum StackIdentifier: Hashable {
        case exerciseListView
        case exerciseDetailView(exercise: Exercise)
    }
    
    
    enum SheetyIdentifier: Identifiable, Hashable {
        
        var id: Int { self.hashValue }
        
        case createExerciseView(dismiss: (Exercise?) -> Void, uuid: UUID)
        
        static func == (lhs: ExerciseNavigationFlow.SheetyIdentifier, rhs: ExerciseNavigationFlow.SheetyIdentifier) -> Bool {
            
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            
            if case let .createExerciseView(dismiss, uuid) = self {
                let stringValue = String(reflecting: dismiss)
                hasher.combine(uuid)
            }
        }
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
        case let .createExerciseView(dismiss, _): return exerciseUIComposer?.makeCreateExerciseViewWithStackNavigation(dismiss: dismiss)
        }
    }
}

