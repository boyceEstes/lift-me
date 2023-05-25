//
//  WorkoutView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI
import RoutineRepository


public struct RoutineRecordViewModel: Hashable {

    public let creationDate: Date
    public var exerciseRecordViewModels: [ExerciseRecordViewModel]
    
    public func mapToRoutineRecord(completionDate: Date) -> RoutineRecord {
        RoutineRecord(
            id: UUID(),
            creationDate: creationDate,
            completionDate: completionDate,
            exerciseRecords: exerciseRecordViewModels.map {
                ExerciseRecord(
                    id: UUID(),
                    setRecords: $0.setRecordViewModels.map {
                        // You cannot have 0 reps #businessRule - should be done somewhere
                        // else, but anyway: You can have a 0 weight. So if nothing is
                        // set for the weight, we will assume its zero.
                        
                        // If rep count is empty we will error - set it to negative 1
                        SetRecord(
                            id: UUID(),
                            duration: nil,
                            repCount: ($0.repCount.isEmpty ? -1 : Double($0.repCount)) ?? -1,
                            weight: ($0.weight.isEmpty ? 0 : Double($0.weight)) ?? 0,
                            difficulty: nil
                        )
                    },
                    exercise: $0.exercise
                )
            }
        )
    }
}


public struct ExerciseRecordViewModel: Hashable {
    
    public var setRecordViewModels: [SetRecordViewModel]
    public let exercise: Exercise
    
    
    mutating func addNewSetRecordViewModel() {
        setRecordViewModels.append(SetRecordViewModel(weight: "", repCount: ""))
    }
}


public struct SetRecordViewModel: Hashable {
    
    public var weight: String
    public var repCount: String
}


public class WorkoutViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    let routine: Routine?
    let dismiss: () -> Void
    let goToCreateRoutineView: (RoutineRecord) -> Void

    
    @Published var routineRecordViewModel: RoutineRecordViewModel = RoutineRecordViewModel(creationDate: Date(), exerciseRecordViewModels: [])
    @Published var displaySaveError = false
    @Published var displaySaveCreateRoutine = false
    
    var isSaveDisabled: Bool {
        routineRecordViewModel.exerciseRecordViewModels.isEmpty
    }
    
    public init(routineStore: RoutineStore, routine: Routine? = nil, goToCreateRoutineView: @escaping (RoutineRecord) -> Void, dismiss: @escaping () -> Void) {
        
        self.routineStore = routineStore
        self.routine = routine
        self.goToCreateRoutineView = goToCreateRoutineView
        self.dismiss = dismiss
        
        populateRoutineRecordFromRoutineIfPossible()
    }
    
    
    func createNewRoutineRecord() {
    }
    
    
    func readLatestRoutineRecord() {
    }
    
    
    private func populateRoutineRecordFromRoutineIfPossible() {

        guard let routine = routine else { return }
        
        routineRecordViewModel.exerciseRecordViewModels = routine.exercises.map { exercise in
            ExerciseRecordViewModel(
                setRecordViewModels: [
                    SetRecordViewModel(weight: "", repCount: "")
                ],
                exercise: exercise
            )
        }
    }
    
    
    // Passed to AddExerciseViewModel for logic after Add button is tapped
    public func addExercisesCompletion(exercises: [Exercise]) {
        print("add exercises completion in workout view: received: \(exercises)")
        
        for exercise in exercises {
            let setRecordViewModel = SetRecordViewModel( weight: "", repCount: "")
            let exerciseRecordViewModel = ExerciseRecordViewModel(setRecordViewModels: [setRecordViewModel], exercise: exercise)
            
            routineRecordViewModel.exerciseRecordViewModels.append(exerciseRecordViewModel)
        }
    }
    
    
    func didTapSaveButton() {
        
        // TODO: Move this since it isn't needed if routine is nil
        guard let routineRecord = getRoutineRecordFromCurrentState() else { return }
        
        if routine == nil {
            // There is no associated routine, do you want to create one?
            displaySaveCreateRoutine = true
            
        } else {
            
            saveRoutineRecord(routineRecord: routineRecord, routine: routine)
        }
    }
    
    
    func getRoutineRecordFromCurrentState() -> RoutineRecord? {
        
        print("validate all fields are entered")
        let routineRecord = routineRecordViewModel.mapToRoutineRecord(completionDate: Date())
        
        guard allSetRecordsHaveValues(routineRecord: routineRecord) else {
            displaySaveError = true
            return nil
        }
        
        print("Going through next logic steps for save...")
        return routineRecord
    }
    
    
    func saveRoutineRecordWithoutSavingRoutineAndDismiss() {
        
        guard let routineRecord = getRoutineRecordFromCurrentState() else { return }

        saveRoutineRecord(routineRecord: routineRecord, routine: nil)
    }
    
    
    
    func saveRoutineRecord(routineRecord: RoutineRecord, routine: Routine?) {
        
        routineStore.createRoutineRecord(routineRecord, routine: routine) { [weak self] error in
            
            if error != nil {
                // There was an issue
                fatalError("error: \(error?.localizedDescription ?? "unknown")")
            }
            
            self?.dismiss()
        }
    }
    
    
    func createRoutineAndSaveRoutineRecord() {
        
        print("validate all fields are entered")
        let routineRecord = routineRecordViewModel.mapToRoutineRecord(completionDate: Date())
        
        guard allSetRecordsHaveValues(routineRecord: routineRecord) else {
            displaySaveError = true
            return
        }
        
        // Send the routine record to the new view, set up the name and any other information and then save it all on that view
        // dismiss all of the modals from there.
        print("Going to make the create routine appear")
        goToCreateRoutineView(routineRecord)
    }
    
    
    private func allSetRecordsHaveValues(routineRecord: RoutineRecord) -> Bool {
        
        var foundMissing = true
        
        routineRecord.exerciseRecords.forEach {
            $0.setRecords.forEach {
                // -1 means that there was no value inputted
                if $0.repCount == -1 {
                    foundMissing = false
                }
            }
        }
        
        return foundMissing
    }
}


public struct WorkoutView: View {
    
    public let inspection = Inspection<Self>()
    
    @ObservedObject public var viewModel: WorkoutViewModel
    let goToAddExercise: () -> Void


    public init(viewModel: WorkoutViewModel, goToAddExercise: @escaping () -> Void) {
        
        self.viewModel = viewModel
        self.goToAddExercise = goToAddExercise
    }
    
    
    public var body: some View {
        VStack {
            
            HStack {
                Button("Save") {
                    
                    viewModel.didTapSaveButton()
                    
                }
                .buttonStyle(LowKeyButtonStyle())
                .disabled(viewModel.isSaveDisabled)
            }
            
            HStack {
                Text("Exercises")
                    .textCase(.uppercase)
                    .padding(.trailing, 6)
                
                Button {
                    goToAddExercise()
                } label: {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(HighKeyButtonStyle())
                .id("add-exercise-button")

                Spacer()
                EditButton()
                    .foregroundColor(.universeRed)
            }
            .font(.headline)
            
            
            List {
                if viewModel.routineRecordViewModel.exerciseRecordViewModels.isEmpty {
                    Text("Try adding an exercise!")
                } else {
                    
                    ForEach(0..<viewModel.routineRecordViewModel.exerciseRecordViewModels.count, id: \.self) { index in
                        ExerciseRecordView(exerciseRecordViewModel: $viewModel.routineRecordViewModel.exerciseRecordViewModels[index])
                    }
                }
            }
        }
        .navigationTitle("Custom Workout")
        .onAppear {

            viewModel.createNewRoutineRecord()
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
        .alert("Not Yet", isPresented: $viewModel.displaySaveError, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text("Make sure you fill out all of your sets")
        })
        .alert("Create Routine?", isPresented: $viewModel.displaySaveCreateRoutine, actions: {
            Button("Sounds Good", role: .cancel) {
                viewModel.createRoutineAndSaveRoutineRecord()
            }
            Button("Nah", role: .destructive) {
                viewModel.saveRoutineRecordWithoutSavingRoutineAndDismiss()
            }
        }, message: {
            Text("Would you like to create a routine based on this workout?")
        })
    }
}


public struct ExerciseRecordView: View {

    @Binding var exerciseRecordViewModel: ExerciseRecordViewModel
    

    public var body: some View {
        
        Section {
            ForEach(0..<exerciseRecordViewModel.setRecordViewModels.count, id: \.self) { index in
                
                SetRecordView(setRecordViewModel: $exerciseRecordViewModel.setRecordViewModels[index], rowNumber: index + 1)
            }
        } header: {
            HStack {
                Text(exerciseRecordViewModel.exercise.name)
                Spacer()
                Button("Add Set") {
                    
                    $exerciseRecordViewModel.wrappedValue.addNewSetRecordViewModel()
                }.buttonStyle(HighKeyButtonStyle())
            }
        }
    }
}


public struct SetRecordView: View {
    
    private enum Field: Int, CaseIterable {
        case repCountValue
        case weightValue
    }
    
    @Binding var setRecordViewModel: SetRecordViewModel
    @FocusState private var focusedField: Field?
    
    let rowNumber: Int
    
    public var body: some View {
        
        HStack {
            Text("Set \(rowNumber)")
            
            Spacer()
            
            HStack {

                TextField("100", text: $setRecordViewModel.weight)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 50)
                    .focused($focusedField, equals: .weightValue)
                
                Text("x")
                TextField("10", text: $setRecordViewModel.repCount)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 50)
                    .focused($focusedField, equals: .repCountValue)
            }
        }
    }
}


struct WorkoutView_Previews: PreviewProvider {
    
    @State static var setRecord = SetRecordViewModel(weight: "", repCount: "")
    
    static var previews: some View {
        let viewModel = WorkoutViewModel(routineStore: RoutineStorePreview(), goToCreateRoutineView: { _ in }, dismiss: { })
        WorkoutView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
        
        SetRecordView(setRecordViewModel: $setRecord, rowNumber: 1)
    }
}
