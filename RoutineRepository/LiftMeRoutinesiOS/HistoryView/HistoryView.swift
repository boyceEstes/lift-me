//
//  HistoryView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository


public class HistoryViewModel: ObservableObject {
    
    private let routineStore: RoutineStore
    @Published var routineRecords = [RoutineRecord]()
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    func readAllRoutineRecords() {
        
        routineStore.readAllRoutineRecords { [weak self] result in
            switch result {
            case let .success(routineRecords):
                self?.routineRecords = routineRecords
                
            case let .failure(error):
                // TODO: Error handling for this
                fatalError("Woah, didn't expect this: \(error)")
            }
        }
    }
}


public struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    
    public let inspection = Inspection<Self>()
    
    public init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .onAppear {
            viewModel.readAllRoutineRecords()
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        HistoryView(viewModel: HistoryViewModel(routineStore: RoutineStorePreview()))
    }
}
