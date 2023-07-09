//
//  CreateRoutineNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/13/23.
//

import SwiftUI
import RoutineRepository


class CreateRoutineNavigationFlow: NewSheetyNavigationFlow {
    
    @Published var displayedSheet: SheetyIdentifier?

    // MARK: - Sheet
    enum SheetyIdentifier: Identifiable, Hashable {

        var id: Int { self.hashValue }
        
        case addExercise(
            addExercisesCompletion: ([Exercise]) -> Void,
            dismiss: () -> Void
        )
        
        
        static func == (lhs: CreateRoutineNavigationFlow.SheetyIdentifier, rhs: CreateRoutineNavigationFlow.SheetyIdentifier) -> Bool {
            lhs.id == rhs.id
        }
        
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(0)
        }
    }
}
