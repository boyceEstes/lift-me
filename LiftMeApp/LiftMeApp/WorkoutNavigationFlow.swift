//
//  WorkoutNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import NavigationFlow
import SwiftUI


class WorkoutNavigationFlow: SheetyNavigationFlow {
    
    
    enum SheetyIdentifier: Identifiable {
        
        var id: Int { self.hashValue }
        
        case addExercise
    }
    
    
    let workoutUIComposer: WorkoutUIComposer
    
    init(workoutUIComposer: WorkoutUIComposer) {
        
        self.workoutUIComposer = workoutUIComposer
    }
    
    // TODO: Make the SheetyIdentifier a CurrentValueSubject to be more resilient to coding errors
    @Published var modallyDisplayedView: SheetyIdentifier? = nil {
        willSet {
            print("current: \(modallyDisplayedView), new: \(newValue)")
        }
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        
        switch identifier {
            
        case .addExercise:
            return workoutUIComposer.makeAddExerciseView()
        }
    }
}
