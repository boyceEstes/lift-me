//
//  ExerciseListView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 2/12/23.
//

import SwiftUI
import RoutineRepository
import Combine


public class ExercisesViewModel: ObservableObject {
    
    @Published var exercises = [Exercise]()
    
    let routineStore: RoutineStore
    let goToExerciseDetailView: (Exercise) -> Void
    let goToCreateExerciseView: () -> Void
    
    var cancellables = Set<AnyCancellable>()
    
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
    
    
    func loadAllExercises() {
        
        routineStore.exerciseDataSource().exercises.sink { error in
            
            // TODO: Handle error case
            fatalError("Deal with the loading error \(error)")
            
        } receiveValue: { [weak self] exercises in
            
            guard let self = self else { return }
            self.exercises = exercises
            
        }.store(in: &cancellables)
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
                viewModel.loadAllExercises()
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
