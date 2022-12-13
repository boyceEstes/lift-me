//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI
import RoutineRepository


public class CreateRoutineViewModel: ObservableObject {
    
    let routineRepository: RoutineRepository
    let dismissAction: () -> Void
    
    @Published var name = ""
    @Published var desc = ""
    
    public init(
        routineRepository: RoutineRepository,
        dismissAction: @escaping () -> Void
    ) {
        
        self.routineRepository = routineRepository
        self.dismissAction = dismissAction
    }
    
    
    func saveRoutine() {
        
        let routine = Routine(
            id: UUID(),
            name: name,
            creationDate: Date(),
            exercises: [],
            routineRecords: [])
        
        routineRepository.save(routine: routine) { [weak self] error in
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
        NavigationStack {
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
            routineRepository: RoutineRepositoryPreview(),
            dismissAction: { })
        
        CreateRoutineView(viewModel: viewModel)
    }
}
