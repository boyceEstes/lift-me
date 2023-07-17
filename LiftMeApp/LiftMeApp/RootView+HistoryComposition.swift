//
//  RootView+HistoryComposition.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 7/12/23.
//

import SwiftUI
import RoutineRepository
import LiftMeRoutinesiOS



extension RootView {
    
    @ViewBuilder
    func makeHistoryViewWithStackNavigation() -> some View {
        
        makeHistoryView()
            .flowNavigationDestination(flowPath: $historyNavigationFlowPath) { identifier in
                
                switch identifier {
                    
                case let .routineRecordDetail(routineRecord):
                    let viewModel = RoutineRecordDetailViewModel(routineRecord: routineRecord)
                    RoutineRecordDetailView(viewModel: viewModel)
                }
            }
    }
    
    
    @ViewBuilder
    private func makeHistoryView() -> some View {
        
        HistoryView(
            routineStore: routineStore,
            goToRoutineRecordDetailView: goToRoutineRecordDetailFromHistory
        )
    }
    
    
    // MARK: - Navigation
    func goToRoutineRecordDetailFromHistory(routineRecord: RoutineRecord) {
        historyNavigationFlowPath.append(.routineRecordDetail(routineRecord))
    }
}
