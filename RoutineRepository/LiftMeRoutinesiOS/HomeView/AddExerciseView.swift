//
//  AddExerciseView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/12/23.
//

import SwiftUI
import RoutineRepository

public class AddExerciseViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    @Published var filteredExercises = [Exercise]()
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    func loadAllExercises() {
        routineStore.readAllExercises() { [weak self] result in
            
            switch result {
            case let .success(exercises):
                self?.filteredExercises = exercises
                
            case let .failure(_):
                break
            }
        }
    }
    
    
    func createExercise() {
        
        let exercise = Exercise(
            id: UUID(),
            name: "Bench Press",
            creationDate: Date(),
            exerciseRecords: [],
            tags: [])
        
        routineStore.createExercise(exercise) { error in
            if error != nil {
                // failure
            }
        }
    }
}


public struct AddExerciseView: View {
    
    @ObservedObject var viewModel: AddExerciseViewModel
    public let inspection = Inspection<Self>()
    
    
    public init(viewModel: AddExerciseViewModel) {
        
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        VStack {
            Button("Create") {
                viewModel.createExercise()
                viewModel.loadAllExercises()
            }
            
            List {
                ForEach(viewModel.filteredExercises, id: \.self) { exercise in
                    BasicExerciseRowView(exercise: exercise)
                }
            }
        }
            .onAppear {
                // Do whatever
                viewModel.loadAllExercises()
            }
        // Added for testing
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
    }
}


public struct BasicExerciseRowView: View {
    
    let exercise: Exercise
    
    public var body: some View {
        Text(exercise.name)
    }
}


struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(
            viewModel: AddExerciseViewModel(
                routineStore: RoutineStorePreview()
            )
        )
    }
}
