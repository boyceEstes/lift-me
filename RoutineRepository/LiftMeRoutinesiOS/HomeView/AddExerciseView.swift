//
//  AddExerciseView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/12/23.
//

import SwiftUI
import RoutineRepository

public class AddExerciseViewModel {
    
    let routineStore: RoutineStore
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    func loadAllExercises() {
        routineStore.readAllExercises() { _ in }
    }
}


public struct AddExerciseView: View {
    
    public let viewModel: AddExerciseViewModel
    public let inspection = Inspection<Self>()
    
    
    public init(viewModel: AddExerciseViewModel) {
        
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        Text("Select Exercises to add here")
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


struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(
            viewModel: AddExerciseViewModel(routineStore: RoutineStorePreview()))
    }
}
