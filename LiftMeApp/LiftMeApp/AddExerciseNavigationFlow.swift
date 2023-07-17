//
//  AddExerciseNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 4/7/23.
//

import NavigationFlow
import RoutineRepository
import SwiftUI


// This is for any view that can be navigated to from AddExercise
class AddExerciseNavigationFlow: NewSheetyNavigationFlow {
    
    @Published var displayedSheet: SheetyIdentifier?
    
    // MARK: - Sheet
    enum SheetyIdentifier: Identifiable, Hashable {
        
        case createExercise(createExerciseCompletion: (Exercise) -> Void)

        
        // Conformance to protocols
        var id: Int { self.hashValue }
        
        
        static func == (lhs: AddExerciseNavigationFlow.SheetyIdentifier, rhs: AddExerciseNavigationFlow.SheetyIdentifier) -> Bool {
            
            lhs.hashValue == rhs.hashValue
        }


        func hash(into hasher: inout Hasher) {
            
            switch self {
            case let .createExercise(createExerciseCompletion):
                
                let stringValue = String(reflecting: createExerciseCompletion)
                hasher.combine(stringValue)
            }
        }
    }
}
