//
//  WorkoutUIComposerWithSpys.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/25/23.
//

import Foundation
@testable import LiftMeApp

class WorkoutUIComposerWithSpys: WorkoutUIComposer {
    
    convenience init() {
        self.init(
            routineStore: RoutineStoreSpy(),
            createRoutineUIComposer: CreateRoutineUIComposerWithSpys(),
            addExerciseUIComposer: AddExerciseUIComposerWithSpys(),
            exerciseUIComposer: ExerciseUIComposerWithSpys())
    }
}
