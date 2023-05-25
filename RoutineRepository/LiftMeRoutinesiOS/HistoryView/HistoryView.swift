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
    var goToRoutineRecordDetailView: (RoutineRecord) -> Void
    
    @Published var routineRecords = [RoutineRecord]()
    
    public init(routineStore: RoutineStore, goToRoutineRecordDetailView: @escaping (RoutineRecord) -> Void) {
        
        self.routineStore = routineStore
        self.goToRoutineRecordDetailView = goToRoutineRecordDetailView
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
        VStack {
            
            List {
                Section("Workouts") {
                    ForEach(viewModel.routineRecords, id: \.self) { routineRecord in
                        RoutineRecordCellView(
                            viewModel: RoutineRecordCellViewModel(
                                routineRecord: routineRecord,
                                goToRoutineRecordDetailView: viewModel.goToRoutineRecordDetailView
                            )
                        )
                    }
                }
            }
        }
        .navigationTitle("History")
        .onAppear {
            viewModel.readAllRoutineRecords()
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}


struct RoutineRecordCellViewModel {
    
    let routineRecord: RoutineRecord
    let goToRoutineRecordDetailView: (RoutineRecord) -> Void
    
    var dateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    
    var completionDateString: String {
        
        guard let completionDate = routineRecord.completionDate else {
            return "No completion date"
        }
        
        return dateFormatter.string(from: completionDate)
    }
    
    
    init(routineRecord: RoutineRecord,
         goToRoutineRecordDetailView: @escaping (RoutineRecord) -> Void) {
        
        self.routineRecord = routineRecord
        self.goToRoutineRecordDetailView = goToRoutineRecordDetailView
    }
}


public struct RoutineRecordCellView: View {
    
    let viewModel: RoutineRecordCellViewModel
    
    public var body: some View {
        

            Button {
                viewModel.goToRoutineRecordDetailView(viewModel.routineRecord)
            } label: {
                HStack {
                    Text(viewModel.completionDateString)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.body)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

        }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        HistoryView(viewModel: HistoryViewModel(routineStore: RoutineStorePreview(), goToRoutineRecordDetailView: { _ in }))
    }
}
