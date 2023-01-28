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
    
    struct SelectableExercise: Hashable {
        
        var isSelected: Bool
        let exercise: Exercise
    }
    
    
    let routineStore: RoutineStore
    
    // Does not get set
    var allSelectableExercises = [SelectableExercise]()
    
//    var selectedExercisesSet = Set<OrderedExercise>() {
//        didSet {
//            let orderedSelectedExercises = selectedExercisesSet.sorted { orderedExercise1, orderedExercise2 in
//                orderedExercise1.orderIndex < orderedExercise2.orderIndex
//            }
//            selectedExercises = orderedSelectedExercises.map { $0.exercise }
//        }
//    }

    @Published var selectedExercises = [Exercise]()
    @Published var selectableFilteredExercises = [SelectableExercise]()
    @Published var selectableSelectedExercises = [SelectableExercise]()
    @Published var searchTextField = ""
    
    var cancellables = Set<AnyCancellable>()
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
        
        bindSearchTextFieldChange()
        bindChangesToSelectableFilteredExercises()
//        bindChangesToSelectableSelectedExercises()
    }
    
    
    func loadAllExercises() {
        routineStore.readAllExercises() { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(exercises):
                // We are doing this first - If we delete an exercise `loadAllExercises`
                self.allSelectableExercises = exercises.map { SelectableExercise(isSelected: false, exercise: $0) }
                self.selectableFilteredExercises = self.allSelectableExercises
                
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
        
        $searchTextField
            .dropFirst()
//            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] searchTextFieldValue in
                guard let self = self else { return }
                
                print("text field change \(searchTextFieldValue)")
                self.selectableFilteredExercises = searchTextFieldValue.isEmpty ? self.allSelectableExercises : self.filterExercises(by: searchTextFieldValue)
                
            }.store(in: &cancellables)
    }
    
    
    private func filterExercises(by searchTextFieldValue: String) -> [SelectableExercise] {
        
        let exercisesFilteredBySearchTextField = allSelectableExercises.filter { selectableExercise in
            return selectableExercise.exercise.name.localizedCaseInsensitiveContains(searchTextFieldValue)
        }
        
        return exercisesFilteredBySearchTextField
    }
    
    
    private func bindChangesToSelectableFilteredExercises() {
        
        $selectableFilteredExercises
            .dropFirst()
            .sink { [weak self] selectableFilteredExercises in
                
                guard let self = self else { return }
                
                self.selectableSelectedExercises = selectableFilteredExercises.filter { $0.isSelected }
            }.store(in: &cancellables)
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
            
            List {
                ForEach($viewModel.selectableSelectedExercises, id: \.self) { selectableExercise in
                    
                    SelectableBasicExerciseRowView(selectableExercise: selectableExercise)
                }
                .accessibilityIdentifier("selected_exercise_list")
            }
            
            
            Button("Create") {
                viewModel.createExercise()
                viewModel.loadAllExercises()
            }
            
            TextField("Hello world", text: $viewModel.searchTextField, prompt: Text("Ex: Bench Press"))
            
            List {
                ForEach($viewModel.selectableFilteredExercises, id: \.self) { selectableExercise in
//                    BasicExerciseRowView(exercise: selectableExercise)
                    SelectableBasicExerciseRowView(selectableExercise: selectableExercise)
                }
                .accessibilityIdentifier("filtered_exercise_list")
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


public struct SelectableBasicExerciseRowView: View {
    
    @Binding var selectableExercise: AddExerciseViewModel.SelectableExercise
    
    public var body: some View {
        
        HStack {
            selectableExercise.isSelected ? Image(systemName: "circle.fill") : Image(systemName: "circle")
            BasicExerciseRowView(exercise: selectableExercise.exercise)
        }
        .accessibilityIdentifier("selectable_filtered_row_\(selectableExercise.exercise.name)")
        .onTapGesture {
            print("tapped selectable row")
            selectableExercise.isSelected.toggle()
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
