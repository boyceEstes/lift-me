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
    
    public struct SelectableExercise2: Hashable {
        
        public var isSelected: Bool
        let exercise: Exercise
    }
    
    
    public class SelectableExercise: Hashable, ObservableObject {
        
        public var isSelected: Bool
        let exercise: Exercise
        
        
        public init(isSelected: Bool, exercise: Exercise) {
            self.isSelected = isSelected
            self.exercise = exercise
        }
        
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(ObjectIdentifier(self))
        }
        
        
        public static func == (lhs: AddExerciseViewModel.SelectableExercise, rhs: AddExerciseViewModel.SelectableExercise) -> Bool {
            return lhs.isSelected == rhs.isSelected && lhs.exercise == rhs.exercise
        }
    }
    
    
    let routineStore: RoutineStore
    let addExerciseCompletion: ([Exercise]) -> Void
    let goToCreateExercise: () -> Void
    let dismiss: () -> Void
    
    // Does not get set
    var allSelectableExercises = [SelectableExercise]()
    

    @Published var selectedExercises = [Exercise]()
    @Published var selectableFilteredExercises = [SelectableExercise]()
    @Published var selectableSelectedExercises = [SelectableExercise]()
    @Published var searchTextField = ""
    
    var cancellables = Set<AnyCancellable>()
    
    public init(
        routineStore: RoutineStore,
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        goToCreateExercise: @escaping () -> Void,
        dismiss: @escaping () -> Void
    ) {
        
        self.routineStore = routineStore
        self.addExerciseCompletion = addExerciseCompletion
        self.goToCreateExercise = goToCreateExercise
        self.dismiss = dismiss
        
        bindSearchTextFieldChange()
        bindDataSource()
    }
    
    
    func bindDataSource() {
        
        routineStore.exerciseDataSource().exercises.sink { error in
            // TODO: Handle this error
            fatalError("uh oh")
            
        } receiveValue: { [weak self] exercises in
            
            guard let self = self else { return }
            self.allSelectableExercises = exercises.map { SelectableExercise(isSelected: false, exercise: $0) }
            self.selectableFilteredExercises = self.allSelectableExercises
            
        }.store(in: &cancellables)
    }
    
    
    func createExercise() {
        
        let exercise = Exercise(
            id: UUID(),
            name: "Bench Press",
            creationDate: Date(),
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
    
    
    func addSelectableExerciseToSelectedList(selectableExercise: SelectableExercise) {
        if !selectableSelectedExercises.contains(selectableExercise) {
            
            selectableExercise.isSelected = true
            selectableSelectedExercises.append(selectableExercise)
        }
    }
    
    
    func removeSelectableExerciseFromSelectedList(selectableExercise: SelectableExercise) {
        
        if selectableSelectedExercises.contains(selectableExercise) {
            
            selectableExercise.isSelected = false
            
            selectableSelectedExercises.removeAll { listCar in
                listCar == selectableExercise
            }
        }
    }
    
    
    func deleteExercise(at offsets: IndexSet) {

        let exercisesToBeRemoved = offsets.map { selectableFilteredExercises[$0] }
        
        for exerciseToBeRemoved in exercisesToBeRemoved {
            
            routineStore.deleteExercise(by: exerciseToBeRemoved.exercise.id) { error in
                if error != nil {
                    fatalError("Handle deletion error")
                }
            }
        }
        
        selectableFilteredExercises.remove(atOffsets: offsets)
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
            
            Button("Add \(viewModel.selectableSelectedExercises.count)") {

                viewModel.addExerciseCompletion(
                    viewModel.selectableSelectedExercises.map {
                        print("Tapped add in AddExerciseView for \($0.exercise.name)")
                        return $0.exercise
                    }
                )
                
                viewModel.dismiss()
            }
            .accessibilityIdentifier("add-selected-exercises")

            SelectedExercisesList(viewModel: viewModel)
            
            Button("Create") {
                viewModel.goToCreateExercise()
//                viewModel.createExercise()
//                viewModel.loadAllExercises()
            }
            
            TextField("Hello world", text: $viewModel.searchTextField, prompt: Text("Ex: Bench Press"))
            
            FilteredAllExercisesList(viewModel: viewModel)
        }
        // Added for testing
            .onReceive(inspection.notice) {
                self.inspection.visit(self, $0)
            }
    }
}


public struct SelectedExercisesList: View {
    
//    @Binding var selectedSelectableExercises: [AddExerciseViewModel.SelectableExercise]
    @ObservedObject var viewModel: AddExerciseViewModel
    
    public var body: some View {
        
        List {
            ForEach($viewModel.selectableSelectedExercises, id: \.self) { selectableExercise in
                
                SelectableBasicExerciseRowView(selectableExercise: selectableExercise) {
                    print("Remove to \(selectableExercise.wrappedValue.exercise.name) from selected list")
                    viewModel.removeSelectableExerciseFromSelectedList(selectableExercise: selectableExercise.wrappedValue)
                }
            }
        }
        .accessibilityIdentifier("selected_exercise_list")
    }
}


public struct FilteredAllExercisesList: View {
    
//    @Binding var filteredAllExercises: [AddExerciseViewModel.SelectableExercise]
    @ObservedObject var viewModel: AddExerciseViewModel
    
    public var body: some View {
        
        List {
            ForEach($viewModel.selectableFilteredExercises, id: \.self) { selectableExercise in
                
                SelectableBasicExerciseRowView(selectableExercise: selectableExercise) {
                    print("Add to \(selectableExercise.wrappedValue.exercise.name) to selected list")
                    if selectableExercise.wrappedValue.isSelected {
                        viewModel.removeSelectableExerciseFromSelectedList(selectableExercise: selectableExercise.wrappedValue)
                    } else {
                        viewModel.addSelectableExerciseToSelectedList(selectableExercise: selectableExercise.wrappedValue)
                    }
                }
            }
            .onDelete(perform: viewModel.deleteExercise)
        }
        .accessibilityIdentifier("filtered_exercise_list")
    }
}


public struct SelectableBasicExerciseRowView: View {
    
    @Binding public var selectableExercise: AddExerciseViewModel.SelectableExercise
    let tapAction: () -> Void
    
    public var body: some View {
        
        Button {
            tapAction()
        } label: {
            HStack {
                selectableExercise.isSelected ? Image(systemName: "circle.fill") : Image(systemName: "circle")
                
                BasicExerciseRowView(exercise: selectableExercise.exercise)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("selectable_row_\(selectableExercise.exercise.name)_\(selectableExercise.isSelected ? "selected" : "unselected")")
    }
}



public struct BasicExerciseRowView: View {
    
    let exercise: Exercise
    
    public var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
        }
    }
}


struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(
            viewModel: AddExerciseViewModel(
                routineStore: RoutineStorePreview(),
                addExerciseCompletion: { _ in },
                goToCreateExercise: { },
                dismiss: { }
            )
        )
    }
}
