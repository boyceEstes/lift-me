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
    let routineRecord: RoutineRecord?
    let dismiss: () -> Void
    let superDismiss: (() -> Void)?
    
    @Published var name = ""
    @Published var desc = ""
    @Published var exercises = [Exercise]()
    
    public init(
        routineStore: RoutineStore,
        routineRecord: RoutineRecord? = nil,
        dismiss: @escaping () -> Void,
        superDismiss: (() -> Void)? = nil
    ) {
        
        self.routineStore = routineStore
        self.routineRecord = routineRecord
        self.dismiss = dismiss
        self.superDismiss = superDismiss
        
        populateExercisesFromRoutineRecordIfPossible()
    }
    
    
    private func populateExercisesFromRoutineRecordIfPossible() {
        
        guard let routineRecord = routineRecord else { return }
        self.exercises = routineRecord.exerciseRecords.map { $0.exercise }
    }
    
    
    func saveButtonTapped() {
        
        var routine: Routine
        
        if let routineRecord = routineRecord {
            
            routine = createRoutine(with: routineRecord)
        } else {
            routine = createRoutine()
        }
        
        saveRoutine(routine: routine)
    }
    
    
    func createRoutine(with routineRecord: RoutineRecord) -> Routine {
        
        let routine = Routine(
            id: UUID(),
            name: name,
            creationDate: Date(),
            exercises: exercises,
            routineRecords: [routineRecord])

        return routine
    }
    
    
    func createRoutine() -> Routine {
        
        let routine = Routine(
            id: UUID(),
            name: name,
            creationDate: Date(),
            exercises: exercises,
            routineRecords: [])

        return routine
    }
    
    
    func saveRoutine(routine: Routine) {
        
        routineStore.createUniqueRoutine(routine) { [weak self] error in
            
            guard let self = self else { return }
            
            if error != nil {
                fatalError("Idk, handle it \(error?.localizedDescription)")
            }
            
            // Dismiss all the way to the root because we have done everything successfully
            if let superDismiss = self.superDismiss {
                
                self.dismiss()
                superDismiss()
            } else {
                self.dismiss()
            }
        }
    }
    
    
    func cancelCreateRoutine() {
        
        dismiss()
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
                
                Section("Exercises") {
                    ForEach(viewModel.exercises, id: \.self) { exercise in
                        HStack {
                            Text(exercise.name)
                        }
                    }
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
                        
                        viewModel.saveButtonTapped()
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
            dismiss: { })
        
        CreateRoutineView(viewModel: viewModel)
    }
}
