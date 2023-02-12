//
//  HistoryNavigationFlow.swift
//  LiftMeApp
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import NavigationFlow



class HistoryNavigationFlow: StackNavigationFlow {
    

    enum StackIdentifier: Hashable {
        
        case historyView
    }
    
    let historyUIComposer: HistoryUIComposer
    
    @Published var path = [StackIdentifier]()
    
    
    init(historyUIComposer: HistoryUIComposer) {
        
        self.historyUIComposer = historyUIComposer
    }
    
    
    func pushToStack(_ identifier: StackIdentifier) -> some View {
        
        switch identifier {
        case .historyView:
            return historyUIComposer.makeHistoryView()
        }
    }
}

