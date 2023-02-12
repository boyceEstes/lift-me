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
    
//    let routineStore: RoutineStore
    
    lazy var navigationFlow: HistoryNavigationFlow = { [unowned self] in
        
        return HistoryNavigationFlow(historyUIComposer: self)
    }()
    
    
//    init(routineStore: RoutineStore) {
//
//        self.routineStore = routineStore
//    }
    
    
    func makeHistoryView() -> HistoryView {
        
        return HistoryView()
    }
}
