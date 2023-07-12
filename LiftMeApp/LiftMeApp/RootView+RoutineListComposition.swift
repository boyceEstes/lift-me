//
//  RootView+RoutineListComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS


extension RootView {
    
    
    func makeRoutineListView(
        routineStore: RoutineStore,
        goToCreateRoutine: @escaping () -> Void,
        goToRoutineDetail: @escaping (Routine) -> Void
    ) -> RoutineListView {
        
        let viewModel = RoutineListViewModel(
            routineStore: routineStore,
            goToCreateRoutine: goToCreateRoutine,
            goToRoutineDetail: goToRoutineDetail
        )
        
        return RoutineListView(viewModel: viewModel)
    }
}
