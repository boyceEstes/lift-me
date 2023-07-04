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
    let exerciseDataSource: ExerciseDataSource
    
    let goToExerciseDetailView: (Exercise) -> Void
    let goToCreateExerciseView: () -> Void
    
    var cancellables = Set<AnyCancellable>()
    
    public init(
        routineStore: RoutineStore,
        goToExerciseDetailView: @escaping (Exercise) -> Void,
        goToCreateExerciseView: @escaping () -> Void
    ) {
        
        self.routineStore = routineStore
        self.goToExerciseDetailView = goToExerciseDetailView
        self.goToCreateExerciseView = goToCreateExerciseView
        
        self.exerciseDataSource = routineStore.exerciseDataSource()
        
        bindDataSource()
    }
    
    
    func bindDataSource() {
        
        exerciseDataSource.exercises.sink { error in
            
            // TODO: Handle error case
            fatalError("Deal with the loading error \(error)")
            
        } receiveValue: { [weak self] exercises in
            
            guard let self = self else { return }
            self.exercises = exercises
            
        }.store(in: &cancellables)
    }
    
    
    func deleteExercise(at offsets: IndexSet) {

        let exercisesToBeRemoved = offsets.map { exercises[$0] }
        
        for exerciseToBeRemoved in exercisesToBeRemoved {
            
            routineStore.deleteExercise(by: exerciseToBeRemoved.id) { error in
                if error != nil {
                    fatalError("Handle deletion error")
                }
            }
        }
        
//        exercises.remove(atOffsets: offsets)
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.goToExerciseDetailView(exercise)
                        }
                }
                .onDelete(perform: viewModel.deleteExercise)
            }
            Spacer()
        }
            .navigationTitle("Exercises")
//            .basicNavigationBar(title: "Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        viewModel.goToCreateExerciseView()
                    }
                    .buttonStyle(LowKeyButtonStyle())
                }
            }
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
        
    }
}


struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExercisesView(viewModel: ExercisesViewModel(routineStore: RoutineStorePreview(), goToExerciseDetailView: { _ in }, goToCreateExerciseView: { }))
        }
    }
}
