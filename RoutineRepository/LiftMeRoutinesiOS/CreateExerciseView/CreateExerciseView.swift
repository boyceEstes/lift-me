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
    
    
    var isSaveButtonDisabled: Bool {
        exerciseName.isEmpty
    }
    
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }

    
    public func saveExercise() {
        
        let exercise = Exercise(id: UUID(), name: exerciseName, creationDate: Date(), tags: [])
        routineStore.createExercise(exercise) { error in
            fatalError("Could not save, \(error?.localizedDescription ?? "no error")")
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
        .navigationTitle("Create Exercise")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    print("Cancel")
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
        CreateExerciseView(viewModel: CreateExerciseViewModel(routineStore: RoutineStorePreview()))
    }
}
