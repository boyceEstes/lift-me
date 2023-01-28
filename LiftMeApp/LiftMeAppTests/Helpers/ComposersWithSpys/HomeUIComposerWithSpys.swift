//
//  HomeUIComposerWithSpys.swift
//  LiftMeAppTests
//
//  Created by Boyce Estes on 1/12/23.
//



import Foundation
@testable import LiftMeApp

class HomeUIComposerWithSpys: HomeUIComposer {
    
    convenience init() {
        self.init(routineStore: RoutineStoreSpy())
    }
}
