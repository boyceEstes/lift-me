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
    let goToExerciseDetailView: (Exercise) -> Void
    let goToCreateExerciseView: () -> Void
    
    public init(
        routineStore: RoutineStore,
        goToExerciseDetailView: @escaping (Exercise) -> Void,
        goToCreateExerciseView: @escaping () -> Void
    ) {
        
        print("init exercise viewmodel")
        self.routineStore = routineStore
        self.goToExerciseDetailView = goToExerciseDetailView
        self.goToCreateExerciseView = goToCreateExerciseView
    }
    
    deinit {
        print("deinit exercise viewmodel")
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
            Button("Create Exercise") {
                viewModel.goToCreateExerciseView()
            }
            
            List {
                ForEach(viewModel.exercises, id: \.self) { exercise in
                    
                    BasicExerciseRowView(exercise: exercise)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.goToExerciseDetailView(exercise)
                        }
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
        ExercisesView(viewModel: ExercisesViewModel(routineStore: RoutineStorePreview(), goToExerciseDetailView: { _ in }, goToCreateExerciseView: { }))
    }
}
