//
//  CreateExerciseView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 3/1/23.
//

import SwiftUI
import RoutineRepository

public class CreateExerciseViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    
    @Published var exerciseName: String = ""
    @Published var exerciseDescription: String = ""
    
    let dismiss: (Exercise?) -> Void
    
    
    var isSaveButtonDisabled: Bool {
        exerciseName.isEmpty
    }
    
    
    public init(routineStore: RoutineStore, dismiss: @escaping (Exercise?) -> Void) {
        
        self.routineStore = routineStore
        self.dismiss = dismiss
    }

    
    public func saveExercise() {
        
        let exercise = Exercise(id: UUID(), name: exerciseName, creationDate: Date(), tags: [])
        routineStore.createExercise(exercise) { [weak self] error in
//
            if let error { fatalError("Could not save, \(error.localizedDescription)") }
            else {
                self?.dismiss(exercise)
            }
        }
    }
}


public struct CreateExerciseView: View {
    
    public let inspection = Inspection<Self>()
    
    @ObservedObject public var viewModel: CreateExerciseViewModel
    
    public init(viewModel: CreateExerciseViewModel) {
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        Form {
            TextField("Name", text: $viewModel.exerciseName)
                .accessibilityIdentifier("exercise_name")
                
            TextField("Description", text: $viewModel.exerciseDescription)
                .accessibilityIdentifier("exercise_description")
        }
        .basicNavigationBar(title: "Create Exercise")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    print("Cancel")
                    viewModel.dismiss(nil)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveExercise()
                }
                .disabled(viewModel.isSaveButtonDisabled)
            }
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}


struct CreateExerciseView_Previews: PreviewProvider {
    
    static var previews: some View {
        CreateExerciseView(
            viewModel: CreateExerciseViewModel(
                routineStore: RoutineStorePreview(),
                dismiss: { _ in }
            )
        )
    }
}
