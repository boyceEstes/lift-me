//
//  AddExerciseNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 4/7/23.
//

import Foundation
import NavigationFlow
import RoutineRepository
import SwiftUI


// This is for any view that can be navigated to from AddExercise
class AddExerciseNavigationFlow: SheetyNavigationFlow {
    
    enum SheetyIdentifier: Identifiable, Hashable {

        var id: Int { self.hashValue }
        case createExercise(dismiss: (Exercise?) -> Void, UUID)
        
        static func == (lhs: AddExerciseNavigationFlow.SheetyIdentifier, rhs: AddExerciseNavigationFlow.SheetyIdentifier) -> Bool {
            
            lhs.hashValue == rhs.hashValue
        }
        
        
        func hash(into hasher: inout Hasher) {
            
            switch self {
            case let .createExercise(dismiss, uuid):
                
                let stringValue = String(reflecting: dismiss)
                hasher.combine(stringValue)
                hasher.combine(uuid)
            }
        }
    }
    
    let exerciseUIComposer: ExerciseUIComposer
    @Published var modallyDisplayedView: SheetyIdentifier?
    
    
    init(exerciseUIComposer: ExerciseUIComposer) {
        
        self.exerciseUIComposer = exerciseUIComposer
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {

        Group {
            switch identifier {
           
            case let .createExercise(dismiss, _):
                exerciseUIComposer.makeCreateExerciseViewWithStackNavigation(dismiss: dismiss)
            }
        }
    }
}
