//
//  AddExerciseView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/12/23.
//

import SwiftUI
import RoutineRepository
import Combine

public class AddExerciseViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    
    // Does not get set
    var allExercises = [Exercise]()
    @Published var filteredExercises = [Exercise]()
    @Published var searchTextField = ""
    
    var cancellables = Set<AnyCancellable>()
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
        
        bindSearchTextFieldChange()
    }
    
    
    func loadAllExercises() {
        routineStore.readAllExercises() { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(exercises):
                // We are doing this first - If we delete an exercise `loadAllExercises`
                self.allExercises = exercises
                self.filteredExercises = exercises //self.filterExercises(by: self.searchTextField)
                
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
    
    
    private func bindSearchTextFieldChange() {
        
        print("Bind search text field change")
        
        $searchTextField
            .dropFirst()
//            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] searchTextFieldValue in
                guard let self = self else { return }
                
                print("text field change \(searchTextFieldValue)")
                self.filteredExercises = searchTextFieldValue.isEmpty ? self.allExercises : self.filterExercises(by: searchTextFieldValue)
                
            }.store(in: &cancellables)
    }
    
    
    private func filterExercises(by searchTextFieldValue: String) -> [Exercise] {
        
        let exercisesFilteredBySearchTextField = allExercises.filter { exercise in
            return exercise.name.localizedCaseInsensitiveContains(searchTextFieldValue)
        }
        
        return exercisesFilteredBySearchTextField
    }
}


public struct AddExerciseView: View {
    
    @ObservedObject public var viewModel: AddExerciseViewModel
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
            
            TextField("Hello world", text: $viewModel.searchTextField, prompt: Text("Ex: Bench Press"))
            
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
