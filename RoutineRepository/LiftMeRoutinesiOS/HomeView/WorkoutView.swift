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
            completionDate: nil,
            exerciseRecords: exerciseRecordViewModels.map {
                ExerciseRecord(
                    id: UUID(),
                    setRecords: $0.setRecordViewModels.map {
                        SetRecord(
                            id: UUID(),
                            duration: nil,
                            repCount: $0.repCount.isEmpty ? nil : Int($0.repCount),
                            weight: $0.weight.isEmpty ? nil : Int($0.weight),
                            difficulty: nil)
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
    
    @Published var routineRecordViewModel: RoutineRecordViewModel = RoutineRecordViewModel(creationDate: Date(), exerciseRecordViewModels: [])
    @Published var displaySaveError = false
    
    var isSaveDisabled: Bool {
        routineRecordViewModel.exerciseRecordViewModels.isEmpty
    }
    
    public init(routineStore: RoutineStore) {
        
        self.routineStore = routineStore
    }
    
    
    // we need to store the reference in-memory so that we can update this record whenever
    // are adding exercises or updating the routine in any way
    func createNewRoutineRecord() {
        
//        routineStore.createRoutineRecord { [weak self] result in
//            switch result {
//            case let .success(routineRecord):
//
//                print("Successfully created routine record")
//                self?.routineRecord = routineRecord
//
//            case let .failure(error):
//                print("Failure to create routine record, \(error.localizedDescription)")
//            }
//        }
    }
    
    // To be more performant, we could just deal with all of this in memory and
    // try to implement core data saving logic whenever we are backgrounding the app or closing it?
    
    // Or we can just do this as we go?
    // 1. So whenever we come here for the first time. Create a RoutineRecord
    // 2. Whenever we add exercises, update that routine record and load current from core data
    // 3. Whenever we add to a set, save to core data as well and then load from core data
    
    // Whenever we are opening this up, we should do a query for any routine records that do not
    // have a completion date - If there is, get that instead of making a new routine record
    func readLatestRoutineRecord() {
        
//        // We need an ID that we can use to fetch the latest information
//        guard let routineRecord = routineRecord else { return }
//
//        routineStore.readRoutineRecord(with: routineRecord.id) { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case let .success(routineRecord):
//                self.routineRecord = routineRecord
//
//            case let .failure(error):
//                fatalError("Need to deal with error for reading routine record with id, \(error)")
//            }
//        }
    }
    
    
    // Passed to AddExerciseViewModel for logic after Add button is tapped
    public func addExercisesCompletion(exercises: [Exercise]) {
        print("add exercises completion in workout view: received: \(exercises)")
        
        // We need to update Core Data with the new exercises
        // Then load the routine record from what is in Core Data
        
        // create an exercise record
        
        for exercise in exercises {
            let setRecordViewModel = SetRecordViewModel( weight: "", repCount: "")
            let exerciseRecordViewModel = ExerciseRecordViewModel(setRecordViewModels: [setRecordViewModel], exercise: exercise)
            
            routineRecordViewModel.exerciseRecordViewModels.append(exerciseRecordViewModel)
        }
    }
    
    
    func didTapSaveButton() {
        
        saveRoutineRecord()
        // ask if you want the routine
        // dismiss the view
    }
    
    
    func saveRoutineRecord() {
        
        print("validate all fields are entered")
        let routineRecord = routineRecordViewModel.mapToRoutineRecord(completionDate: Date())
        
        guard allSetRecordsHaveValues(routineRecord: routineRecord) else {
            displaySaveError = true
            return
        }
        
        print("saaving routine record")

        routineStore.createRoutineRecord(routineRecord) { error in
            
            if error != nil {
                // There was an issue
                fatalError("error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    private func allSetRecordsHaveValues(routineRecord: RoutineRecord) -> Bool {
        
        var foundMissing = true
        
        routineRecord.exerciseRecords.forEach {
            $0.setRecords.forEach {
                if $0.repCount == nil || $0.weight == nil {
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
        let viewModel = WorkoutViewModel(routineStore: RoutineStorePreview())
        WorkoutView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
        
        SetRecordView(setRecordViewModel: $setRecord, rowNumber: 1)
    }
}
