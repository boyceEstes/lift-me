//
//  RoutineUIComposer.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 11/3/22.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS


public final class RoutineListUIComposer {
    
    private init() {}
    
    
    public static func routineListComposedWith(routineRepository: RoutineRepository) -> RoutineListView {
        
        let viewModel = RoutineViewModel(routineRepository: routineRepository)
        return RoutineListView(viewModel: viewModel)
    }
}

