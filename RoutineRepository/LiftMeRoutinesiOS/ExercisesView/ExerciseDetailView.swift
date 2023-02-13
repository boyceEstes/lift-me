//
//  ExerciseDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository

public class ExerciseDetailViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    let exercise: Exercise
    
    public init(routineStore: RoutineStore, exercise: Exercise) {
        
        self.routineStore = routineStore
        self.exercise = exercise
    }
}


public struct ExerciseDetailView: View {
    
    @ObservedObject var viewModel: ExerciseDetailViewModel
    
    public init(viewModel: ExerciseDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Text("Hello world")
            .navigationTitle(viewModel.exercise.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseDetailView(
                viewModel: ExerciseDetailViewModel(
                    routineStore: RoutineStorePreview(),
                    exercise: Exercise(
                        id: UUID(),
                        name: "Any exercise",
                        creationDate: Date(),
                        tags: []
                    )
                )
            )
        }
    }
}
