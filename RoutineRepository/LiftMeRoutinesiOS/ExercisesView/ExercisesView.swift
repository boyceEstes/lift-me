//
//  ExerciseListView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository


public class ExercisesViewModel: ObservableObject {
    
    @Published var exercises = [Exercise]()
    
    let routineStore: RoutineStore
    
    public init(routineStore: RoutineStore) {
        self.routineStore = routineStore
    }
    
    func readAllExercises() {
        
        routineStore.readAllExercises { result in
            switch result {
            case let .success(exercises):
                self.exercises = exercises
                
            case let .failure(error):
                fatalError("Deal with the loading error \(error)")
            }
        }
    }
}


public struct ExercisesView: View {
    
    @ObservedObject var viewModel: ExercisesViewModel
    
    public let inspection = Inspection<Self>()
    
    
    public init(viewModel: ExercisesViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            List {
                ForEach(viewModel.exercises, id: \.self) { exercise in
                    
                    BasicExerciseRowView(exercise: exercise)
                }
            }
            Spacer()
        }
            .navigationTitle("Exercises")
            .onAppear {
                viewModel.readAllExercises()
            }
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
    }
}


struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(viewModel: ExercisesViewModel(routineStore: RoutineStorePreview()))
    }
}
