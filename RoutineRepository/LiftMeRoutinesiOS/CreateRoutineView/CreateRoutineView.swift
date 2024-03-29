//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI
import RoutineRepository


public class CreateRoutineViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    let routineRecord: RoutineRecord?

    var dismiss: (() -> Void)? // Set in View from Environment dismiss
    let goToAddExercise: (@escaping ([Exercise]) -> Void) -> Void
    let goToExerciseDetail: (Exercise) -> Void
    let superDismiss: (() -> Void)?
    
    @Published var name = ""
    @Published var desc = ""
    @Published var exercises = [Exercise]()
    
    public init(
        routineStore: RoutineStore,
        routineRecord: RoutineRecord? = nil,
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToExerciseDetail: @escaping (Exercise) -> Void,
        superDismiss: (() -> Void)? = nil
    ) {
        
        self.routineStore = routineStore
        self.routineRecord = routineRecord
        self.goToAddExercise = goToAddExercise
        self.goToExerciseDetail = goToExerciseDetail
        self.superDismiss = superDismiss
        
        populateExercisesFromRoutineRecordIfPossible()
    }
    
    
    var isSaveButtonDisabled: Bool {
        
        name.isEmpty || exercises.isEmpty
    }
    
    
    private func populateExercisesFromRoutineRecordIfPossible() {
        
        guard let routineRecord = routineRecord else { return }
        self.exercises = routineRecord.exerciseRecords.map { $0.exercise }
    }
    
    
    func saveButtonTapped() {
        
        var routine: Routine
        
        if let routineRecord = routineRecord {
            
            routine = createRoutine(with: [routineRecord])
        } else {
            routine = createRoutine()
        }
        
        saveRoutine(routine: routine)
    }
    
//
//    public func addExercisesCompletion(exercises: [Exercise]) {
//
//        exercises.forEach { [weak self] in
//
//            print("Appending \($0.name)")
//            self?.exercises.append($0)
//        }
//    }
//
//
    func createRoutine(with routineRecords: [RoutineRecord]? = nil) -> Routine {
        
        let routine = Routine(
            id: UUID(),
            name: name,
            creationDate: Date(),
            exercises: exercises,
            routineRecords: routineRecords ?? [])

        return routine
    }
    
    
    func saveRoutine(routine: Routine) {
        
        routineStore.createUniqueRoutine(routine) { [weak self] error in
            
            guard let self = self else { return }
            
            if let error = error {
                self.handleError(error: error, saving: routine)
            } else {
                // Dismiss all the way to the root because we have done everything successfully
                if let superDismiss = self.superDismiss {
                    
                    self.dismiss?()
                    superDismiss()
                } else {
                    self.dismiss?()
                }
            }
        }
    }
    
    
    func cancelCreateRoutine() {
        
        dismiss?()
    }
    
    
    private func handleError(error: Error, saving routine: Routine) {
        
        if case CoreDataRoutineStore.Error.routineWithNameAlreadyExists = error {
            // calculate new name and try saving again
            let uniquelyNamedRoutine = uniquelyNamedRoutine(from: routine)
            saveRoutine(routine: uniquelyNamedRoutine)
            
        } else {
            displayAlert(with: error)
        }
    }
    
    
    private func displayAlert(with error: Error) {
        // TODO: Display an alert saving the routine
    }
    
    
    private func uniquelyNamedRoutine(from routine: Routine) -> Routine {
        
        // Create unique name based on the given routine
        let uniquelyNamedRoutine = Routine(
            id: routine.id,
            name: NamingPolicy.uniqueName(from: routine.name),
            creationDate: routine.creationDate,
            exercises: routine.exercises,
            routineRecords: routine.routineRecords
        )
        return uniquelyNamedRoutine
    }
    
    
    func updateExercisesFromAddExercise(newExercises: [Exercise]) {
        exercises.append(contentsOf: newExercises)
    }

    
    func goToAddExerciseWithCompletionHandled() {
        goToAddExercise { [weak self] addedExercises in
            self?.updateExercisesFromAddExercise(newExercises: addedExercises)
        }
    }
}


public struct CreateRoutineView: View {
    
    public let inspection = Inspection<Self>()
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CreateRoutineViewModel
    

    public init(
        routineStore: RoutineStore,
        routineRecord: RoutineRecord?, // Only nonnil if creating routine from workout
        superDismiss: (() -> Void)?, // Only nonnil if creating routine from workout
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToExerciseDetail: @escaping (Exercise) -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: CreateRoutineViewModel(
            routineStore: routineStore,
            routineRecord: routineRecord,
            goToAddExercise: goToAddExercise,
            goToExerciseDetail: goToExerciseDetail,
            superDismiss: superDismiss
        ))
    }
    
    
    public var body: some View {
        Form {
            TextField(text: $viewModel.name) {
                Text("Name")
            }
            .accessibilityIdentifier("routine_name")
            
            TextField(text: $viewModel.desc) {
                Text("Description")
            }
            .accessibilityIdentifier("routine_description")
            
            EditableExerciseSectionView(
                exercises: $viewModel.exercises,
                goToAddExercise: viewModel.goToAddExerciseWithCompletionHandled,
                goToExerciseDetail: viewModel.goToExerciseDetail
            )
        }
        .basicNavigationBar(title: "Create Routine")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    viewModel.cancelCreateRoutine()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    
                    viewModel.saveButtonTapped()
                }
                .disabled(viewModel.isSaveButtonDisabled)
            }
        }
        .onAppear {
            viewModel.dismiss = dismiss.callAsFunction
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}


struct EditableExerciseSectionView: View {
    
    @Binding private var exercises: [Exercise]
    let goToAddExercise: () -> Void
    let goToExerciseDetail: (Exercise) -> Void
    
    
    init(
        exercises: Binding<[Exercise]>,
        goToAddExercise: @escaping () -> Void,
        goToExerciseDetail: @escaping (Exercise) -> Void
    ) {
        
        self._exercises = exercises
        self.goToAddExercise = goToAddExercise
        self.goToExerciseDetail = goToExerciseDetail
    }
    
    
    var body: some View {
        
        Section {
            ForEach(exercises, id: \.self) { exercise in
                HStack {
                    Button(exercise.name) {
                        goToExerciseDetail(exercise)
                    }
                    .accessibilityIdentifier("exercise_row")
//                    Text(exercise.name)
                        
                }
            }
        } header: {
            HStack {
                Text("Exercises")
                    .font(.headline)
                Spacer()
                Button(action: goToAddExercise) {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(HighKeyButtonStyle())
                .id("add-exercise-button")
                
            }
        } footer: {
            if exercises.isEmpty {
                VStack(alignment: .center) {
                    Text("Much empty. Try adding some exercises")
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
        }
//        .textCase(nil)
    }
}


struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationStack {
            CreateRoutineView(
                routineStore: RoutineStorePreview(),
                routineRecord: nil,
                superDismiss: nil,
                goToAddExercise: { _ in },
                goToExerciseDetail: { _ in }
            )
        }
    }
}
