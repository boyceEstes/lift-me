//
//  ExerciseUIComposerWithSpys.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
@testable import LiftMeApp

class ExerciseUIComposerWithSpys: ExerciseUIComposer {
    
    convenience init() {
        self.init(routineStore: RoutineStoreSpy())
    }
}
