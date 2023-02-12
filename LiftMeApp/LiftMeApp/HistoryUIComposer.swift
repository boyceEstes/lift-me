//
//  HistoryUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS


public class HistoryUIComposer {
    
    let routineStore: RoutineStore
    
    lazy var navigationFlow: HistoryNavigationFlow = { [unowned self] in
        
        return HistoryNavigationFlow(historyUIComposer: self)
    }()
    
    
    public init(routineStore: RoutineStore) {

        self.routineStore = routineStore
    }
    
    
    public func makeHistoryView() -> HistoryView {
        
        let historyViewModel = HistoryViewModel(routineStore: routineStore)
        return HistoryView(viewModel: historyViewModel)
    }
}
