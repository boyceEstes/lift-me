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
    
    
    public struct SelectableExercise: Hashable {
        
        public var isSelected: Bool
        let exercise: Exercise
        
        
        public init(isSelected: Bool, exercise: Exercise) {
            self.isSelected = isSelected
            self.exercise = exercise
        }
        
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(exercise.hashValue)
            hasher.combine(isSelected)
        }
        
        
        public static func == (lhs: AddExerciseViewModel.SelectableExercise, rhs: AddExerciseViewModel.SelectableExercise) -> Bool {
            return lhs.isSelected == rhs.isSelected && lhs.exercise == rhs.exercise
        }
    }
    
    
    let routineStore: RoutineStore
    let exerciseDataSource: ExerciseDataSource
    
    let addExerciseCompletion: ([Exercise]) -> Void
    let goToCreateExercise: (@escaping (Exercise?) -> Void) -> Void
    
    
    @Published public var allSelectableExercises = [SelectableExercise]()

    
    var selectableFilteredExercises: [SelectableExercise] {
        
        var filteredExercises = [SelectableExercise]()
        DispatchQueue.global().sync {
            filteredExercises = allSelectableExercises.filter {
                // TODO: Consider a Debounce operator on searchTextField changes
                // If searchTextField is empty include this object - else
                searchTextField.isEmpty ? true : $0.exercise.name.localizedCaseInsensitiveContains(searchTextField)
            }
        }
        return filteredExercises
    }
    
    var selectableSelectedExercises: [SelectableExercise] {
        var selectedExercises = [SelectableExercise]()
        DispatchQueue.global().sync {
            selectedExercises = allSelectableExercises.filter { $0.isSelected }
        }
        return selectedExercises
    }
    
    
    @Published var searchTextField = ""
    
    var cancellables = Set<AnyCancellable>()
    
    public init(
        routineStore: RoutineStore,
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        goToCreateExercise: @escaping (@escaping (Exercise?) -> Void) -> Void
    ) {
        
        self.routineStore = routineStore
        self.exerciseDataSource = routineStore.exerciseDataSource()
        self.addExerciseCompletion = addExerciseCompletion
        self.goToCreateExercise = goToCreateExercise
        
        bindDataSource()
    }
    
    
    func bindDataSource() {
        
        exerciseDataSource.exercises.sink { error in
            // TODO: Handle this error
            fatalError("uh oh")
            
        } receiveValue: { [weak self] exercises in
            
            guard let self = self else { return }
            self.allSelectableExercises = exercises.map { SelectableExercise(isSelected: false, exercise: $0) }
            
        }.store(in: &cancellables)
    }
    
    
    private func filterExercises(by searchTextFieldValue: String) -> [SelectableExercise] {
        
        let exercisesFilteredBySearchTextField = allSelectableExercises.filter { selectableExercise in
            return selectableExercise.exercise.name.localizedCaseInsensitiveContains(searchTextFieldValue)
        }
        
        return exercisesFilteredBySearchTextField
    }
    
    
    func addSelectableExerciseToSelectedList(selectableExercise: SelectableExercise) {
        
        guard let indexOfSelectedExercise = allSelectableExercises.firstIndex(of: selectableExercise) else { return }
        allSelectableExercises[indexOfSelectedExercise] = SelectableExercise(isSelected: true, exercise: selectableExercise.exercise)
    }
    
    
    func removeSelectableExerciseFromSelectedList(selectableExercise: SelectableExercise) {
        
        guard let indexOfExerciseToRemove = allSelectableExercises.firstIndex(of: selectableExercise) else {
            return
        }
        allSelectableExercises[indexOfExerciseToRemove] = SelectableExercise(isSelected: false, exercise: selectableExercise.exercise)
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
    }
    
    
    func handleGoToCreateExercise() {
        
        goToCreateExercise(handleCreateExerciseCompletion)
    }
    
    
    func handleCreateExerciseCompletion(exercise: Exercise?) {
        
        guard let exercise = exercise else { return }
        guard let selectableExercise = selectableFilteredExercises.filter({ selectableExercise in
            selectableExercise.exercise.id == exercise.id
        }).first else { return}
        
        addSelectableExerciseToSelectedList(selectableExercise: selectableExercise)
    }
}


public struct AddExerciseView: View {

    //    @FocusState private var focus: Field?
    @Environment(\.dismiss) var dismiss
    @StateObject public var viewModel: AddExerciseViewModel
    
    public let inspection = Inspection<Self>()
    
    public init(
        routineStore: RoutineStore,
        addExerciseCompletion: @escaping ([Exercise]) -> Void,
        goToCreateExercise: @escaping (@escaping (Exercise?) -> Void) -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: AddExerciseViewModel(
                routineStore: routineStore,
                addExerciseCompletion: addExerciseCompletion,
                goToCreateExercise: goToCreateExercise
            )
        )
    }
    
    
    public var body: some View {
            
        let _ = print("update AddExeerciseView \(viewModel.allSelectableExercises)")
//        VStack {
        ScrollViewReader { scrollValue in
            
            List {
                if !viewModel.selectableSelectedExercises.isEmpty {
                    Section {
                        SelectedExercisesList(viewModel: viewModel)
                    } header: {
                        Text("Selected Exercises")
                    }
                }
                
                Section {
                    FilteredAllExercisesList(viewModel: viewModel)
                } header: {
                    VStack {
                        Button("Create") {
                            viewModel.handleGoToCreateExercise()
                        }
                        .buttonStyle(LongHighKeyButtonStyle())
                        .accessibilityIdentifier("add-selected-exercises")
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                            // TODO: - 0.1.0 Make a smooth animation whenever the search bar is focused
                            TextField("Search", text: $viewModel.searchTextField, prompt: Text("Ex: Bench Press"))
//                                .focused($focus, equals: .search)
//                                .onChange(of: focus) { newValue in
//                                    withAnimation {
//                                        scrollValue.scrollTo("search_section", anchor: .top)
//                                    }
//                                }
                        }
                        .padding()
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(10)
                    }
                }
                .id("search_section")
                .textCase(nil)
            }
        }
        .basicNavigationBar(title: "Add Exercise")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button("Add \(viewModel.selectableSelectedExercises.count)") {
                    viewModel.addExerciseCompletion(
                        viewModel.selectableSelectedExercises.map {
                            print("Tapped add in AddExerciseView for \($0.exercise.name)")
                            return $0.exercise
                        }
                    )
                    
                    dismiss()
                }
                
            }
        }
        // Added for testing
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

public struct SelectedExercisesList: View {
    
//    @Binding var selectedSelectableExercises: [AddExerciseViewModel.SelectableExercise]
    @ObservedObject var viewModel: AddExerciseViewModel
    
    public var body: some View {
            
            ForEach(viewModel.selectableSelectedExercises, id: \.self) { selectableExercise in
                
                SelectableBasicExerciseRowView(selectableExercise: selectableExercise) {
                    print("Remove to \(selectableExercise.exercise.name) from selected list")
                    viewModel.removeSelectableExerciseFromSelectedList(selectableExercise: selectableExercise)
                }
            }
            .accessibilityIdentifier("selected_exercise_list")
    }
}


public struct FilteredAllExercisesList: View {
    
//    @Binding var filteredAllExercises: [AddExerciseViewModel.SelectableExercise]
    @ObservedObject var viewModel: AddExerciseViewModel
    
    public var body: some View {
        
//        List {
            ForEach(viewModel.selectableFilteredExercises, id: \.self) { selectableExercise in
                
                SelectableBasicExerciseRowView(selectableExercise: selectableExercise) {
                    if selectableExercise.isSelected {
                        viewModel.removeSelectableExerciseFromSelectedList(selectableExercise: selectableExercise)
                    } else {
                        viewModel.addSelectableExerciseToSelectedList(selectableExercise: selectableExercise)
                    }
                }
            }
            .onDelete(perform: viewModel.deleteExercise)
//        }
        .accessibilityIdentifier("filtered_exercise_list")
    }
}


public struct SelectableBasicExerciseRowView: View {
    
    public var selectableExercise: AddExerciseViewModel.SelectableExercise
    let tapAction: () -> Void
    
    public var body: some View {
        
        Button {
            tapAction()
        } label: {
            HStack {
                Group {
                    selectableExercise.isSelected ? Image(systemName: "circle.fill") : Image(systemName: "circle")
                }
                .foregroundColor(.universeRed)
                .fontWeight(.heavy)
                
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
        NavigationStack {
            AddExerciseView(
                routineStore: RoutineStorePreview(),
                addExerciseCompletion: { _ in },
                goToCreateExercise: { _ in }
            )
        }
    }
}
