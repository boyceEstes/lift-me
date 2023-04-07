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
        case createExercise
    }
    
//    let exerciseUIComposer: ExerciseUIComposer
    
    @Published var modallyDisplayedView: SheetyIdentifier?
    
    init() {
    }
    
    
    func displaySheet(for identifier: SheetyIdentifier) -> some View {
        Text("Nothing")
//
//        Group {
//            switch identifier {
//            case let .addExercise(addExercisesCompletion, dismiss):
//                addExerciseUIComposer.makeAddExerciseView(addExerciseCompletion: addExercisesCompletion, dismiss: dismiss)
//            }
//        }
    }
}
