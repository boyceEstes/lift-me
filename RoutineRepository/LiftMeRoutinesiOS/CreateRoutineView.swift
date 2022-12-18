//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI
import RoutineRepository


public class CreateRoutineViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    let dismissAction: () -> Void
    
    @Published var name = ""
    @Published var desc = ""
    
    public init(
        routineStore: RoutineStore,
        dismissAction: @escaping () -> Void
    ) {
        
        self.routineStore = routineStore
        self.dismissAction = dismissAction
    }
    
    
    func saveRoutine() {
        
        let routine = Routine(
            id: UUID(),
            name: name,
            creationDate: Date(),
            exercises: [],
            routineRecords: [])
        
        routineStore.create(routine) { [weak self] error in
            if error != nil {
                print("error: \(error!)")
            }
            self?.dismissAction()
        }
    }
    
    
    func cancelCreateRoutine() {
        
        dismissAction()
    }
}


public struct CreateRoutineView: View {
    
    @ObservedObject var viewModel: CreateRoutineViewModel
    
    
    public init(viewModel: CreateRoutineViewModel) {
        
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        NavigationView {
            Form {
                TextField(text: $viewModel.name) {
                    Text("Name")
                }
                
                TextField(text: $viewModel.desc) {
                    Text("Description")
                }
            }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.cancelCreateRoutine()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
                        viewModel.saveRoutine()
                    }
                }
            }
        }
        
    }
}


struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = CreateRoutineViewModel(
            routineStore: RoutineStorePreview(),
            dismissAction: { })
        
        CreateRoutineView(viewModel: viewModel)
    }
}
