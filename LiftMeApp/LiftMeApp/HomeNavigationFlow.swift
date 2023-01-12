//
//  RoutineNavigationViewModel.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 11/24/22.
//

import SwiftUI
import NavigationFlow
import LiftMeRoutinesiOS
import RoutineRepository


class HomeNavigationFlow: SheetyNavigationFlow {
    
    enum SheetyIdentifier: Identifiable {
        
        var id: Int { self.hashValue }

        case createRoutine
        case workout
        case addExercise
    }
    
    
    let homeUIComposer: HomeUIComposer
    
    
    init(homeUIComposer: HomeUIComposer) {
        
        self.homeUIComposer = homeUIComposer
    }
    
    
    @Published var modallyDisplayedView: SheetyIdentifier? = nil {
        willSet {
            print("current: \(modallyDisplayedView), new: \(newValue)")
        }
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        Group {
            switch identifier {
                
            case .createRoutine:
                homeUIComposer.makeCreateRoutineView()
                
            case .workout:
                homeUIComposer.makeWorkoutView()
                
            case .addExercise:
                homeUIComposer.makeAddExerciseView()
            }
        }
    }
}
