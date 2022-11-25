//
//  RoutineUIComposer.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 11/3/22.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS
import NavigationFlow


public final class RoutineUIComposer {
    
    static let navigationViewModel = RoutineNavigationViewModel()
    
    private init() {}
    
    
    static func makeRoutineListWithStackNavigation(routineRepository: RoutineRepository) -> StackNavigationView<RoutineListView, RoutineNavigationViewModel> {
        
        return StackNavigationView(stackNavigationViewModel: navigationViewModel, content: makeRoutineList(routineRepository: routineRepository))
    }
    
    
    static func makeRoutineList(routineRepository: RoutineRepository) -> RoutineListView {
        
        let viewModel = RoutineViewModel(routineRepository: routineRepository)
        
        return RoutineListView(viewModel: viewModel) {
            navigationViewModel.path.append(.createRoutine)
        }
    }
    
    
    static func makeCreateRoutine() -> CreateRoutineView {
        
        return CreateRoutineView()
    }
}

