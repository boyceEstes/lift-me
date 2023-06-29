//
//  RootView.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS

struct RootView: View {
    
    let homeUIComposer: HomeUIComposer
    let workoutUIComposer: WorkoutUIComposer
    let addExerciseUIComposer: AddExerciseUIComposer
    let exerciseUIComposer: ExerciseUIComposer
    let historyUIComposer: HistoryUIComposer
    let createRoutineUIComposer: CreateRoutineUIComposer
    
    
    init(routineStore: RoutineStore) {
        // Initialize ExercisesNavigationFlow with a weak reference to the composer
        
        self.exerciseUIComposer = ExerciseUIComposer(routineStore: routineStore)
        self.addExerciseUIComposer = AddExerciseUIComposer(
            routineStore: routineStore,
            exerciseUIComposer: exerciseUIComposer
        )
        
        self.createRoutineUIComposer = CreateRoutineUIComposer(
            routineStore: routineStore,
            addExerciseUIComposer: addExerciseUIComposer
        )
        
        self.workoutUIComposer = WorkoutUIComposer(
            routineStore: routineStore,
            createRoutineUIComposer: createRoutineUIComposer,
            addExerciseUIComposer: addExerciseUIComposer,
            exerciseUIComposer: exerciseUIComposer
        )
        
        self.homeUIComposer = HomeUIComposer(
            routineStore: routineStore,
            workoutUIComposer: workoutUIComposer,
            createRoutineUIComposer: createRoutineUIComposer,
            addExerciseUIComposer: addExerciseUIComposer
        )

        self.historyUIComposer = HistoryUIComposer(routineStore: routineStore)
    }
    
    
    var body: some View {
        TabView {
            homeUIComposer.makeHomeViewWithNavigation()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            exerciseUIComposer.makeExercisesViewWithSheetyStackNavigation()
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }
            
            historyUIComposer.makeHistoryViewWithStackNavigation()
                .tabItem {
                    Label("History", systemImage: "book.closed")
                }
        }
//        .toolbarColorScheme(.light, for: .tabBar)
//        .toolbarColorScheme(Color.universeRed, for: .tabBar)
    }
}


//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView(routineStore: RoutineStorePreview.self as! RoutineStore)
//    }
//}
