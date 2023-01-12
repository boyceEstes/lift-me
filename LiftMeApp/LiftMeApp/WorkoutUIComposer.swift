//
//  WorkoutUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 1/12/23.
//

import Foundation
import LiftMeRoutinesiOS
import NavigationFlow


public class WorkoutUIComposer {
    
    lazy var navigationFlow: WorkoutNavigationFlow = { [unowned self] in
        return WorkoutNavigationFlow(workoutUIComposer: self)
    }()
    
    
    // I'm going to need a new NavigationFlow for the workout since I want it to stay up whne it presents its own sheet
    func makeWorkoutViewWithSheetyNavigation() -> SheetyNavigationView<WorkoutView, WorkoutNavigationFlow> {
        
        let workoutView = makeWorkoutView()
        
        return SheetyNavigationView(
            sheetyNavigationViewModel: navigationFlow,
            content: workoutView
        )
    }
    
    
    func makeWorkoutView() -> WorkoutView {
        
        return WorkoutView(
            goToAddExercise: {
                self.navigationFlow.modallyDisplayedView = .addExercise
            }
        )
    }
    
    
    func makeAddExerciseView() -> AddExerciseView {
        
        return AddExerciseView()
    }
}
