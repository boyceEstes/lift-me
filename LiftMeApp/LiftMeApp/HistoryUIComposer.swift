//
//  HistoryUIComposer.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import Foundation
import RoutineRepository
import LiftMeRoutinesiOS
import NavigationFlow


public class HistoryUIComposer {
    
    let routineStore: RoutineStore
    
    lazy var navigationFlow: HistoryNavigationFlow = { [unowned self] in
        
        return HistoryNavigationFlow(historyUIComposer: self)
    }()
    
    
    init(routineStore: RoutineStore) {

        self.routineStore = routineStore
    }
    
    
    func makeHistoryViewWithStackNavigation() -> StackNavigationView<HistoryView, HistoryNavigationFlow> {
        
        let historyView = makeHistoryView()
        
        return StackNavigationView(stackNavigationViewModel: self.navigationFlow, content: historyView)
    }
    
    
    func makeHistoryView() -> HistoryView {
        
        let historyViewModel = HistoryViewModel(
            routineStore: routineStore,
            goToRoutineRecordDetailView: { [weak self] routineRecord in
                
                self?.navigationFlow.path.append(.routineRecordDetailView(routineRecord: routineRecord))
            }
        )
        return HistoryView(viewModel: historyViewModel)
    }
    
    
    func makeRoutineRecordDetailView(routineRecord: RoutineRecord) -> RoutineRecordDetailView {
        
        let routineRecordDetailViewModel = RoutineRecordDetailViewModel(routineRecord: routineRecord)
        return RoutineRecordDetailView(viewModel: routineRecordDetailViewModel)
    }
}
