//
//  RoutineNavigationViewModel.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 11/24/22.
//

import SwiftUI
import NavigationFlow
import LiftMeRoutinesiOS

class RoutineNavigationViewModel: StackNavigationFlow {

    enum StackIdentifier: Hashable {
        
        case createRoutine
    }
    
    
    @Published var path = [StackIdentifier]()
    
    
    func pushToStack(_ identifier: StackIdentifier) -> some View {
        
        switch identifier {
        case .createRoutine:
            return RoutineUIComposer.makeCreateRoutine()
        }
    }
}
