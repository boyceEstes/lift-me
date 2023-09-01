//
//  WorkoutViewModel.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import Foundation
import RoutineRepository


public class WorkoutViewModel: ObservableObject {
    
    let uuid = UUID()
    let startDate = Date()
    
    
    let routineStore: RoutineStore
    let routine: Routine?
    let goToAddExercise: (@escaping ([Exercise]) -> Void) -> Void
    let goToCreateRoutineView: (RoutineRecord) -> Void
    let goToExerciseDetails: (Exercise) -> Void
    // initialized from view
    var dismiss: (() -> Void)?

    
    @Published var routineRecordViewModel: RoutineRecordViewModel = RoutineRecordViewModel(creationDate: Date(), exerciseRecordViewModels: [])
    @Published var displaySaveError = false
    @Published var displaySaveCreateRoutine = false
    @Published var displayDeleteExerciseWarning = false
    var deleteExerciseIndex: Int?
    @Published var workoutNoteState = NoteButtonState.add
    @Published var workoutNoteValue = ""
    
    var isSaveDisabled: Bool {
        routineRecordViewModel.exerciseRecordViewModels.isEmpty
    }
    
    public init(
        routineStore: RoutineStore,
        routine: Routine? = nil,
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToCreateRoutineView: @escaping (RoutineRecord) -> Void,
        goToExerciseDetails: @escaping (Exercise) -> Void
    ) {
        
        self.routineStore = routineStore
        self.routine = routine
        self.goToAddExercise = goToAddExercise
        self.goToCreateRoutineView = goToCreateRoutineView
        self.goToExerciseDetails = goToExerciseDetails
        
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
//        print("add exercises completion in workout view-model(\(uuid.uuidString) - received: \(exercises)")
        
        for exercise in exercises {
            let setRecordViewModel = SetRecordViewModel(weight: "", repCount: "")
            let exerciseRecordViewModel = ExerciseRecordViewModel(setRecordViewModels: [setRecordViewModel], exercise: exercise)
            
            routineRecordViewModel.exerciseRecordViewModels.append(exerciseRecordViewModel)
        }
        
        self.objectWillChange.send()
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
        let routineRecord = routineRecordViewModel.mapToRoutineRecord(note: workoutNoteValue, completionDate: Date())
        
        guard allSetRecordsHaveValues(routineRecord: routineRecord) else {
            displaySaveError = true
            return nil
        }
        
        print("Going through next logic steps for save...")
        return routineRecord
    }
    
    
    // TODO: 1.0.0 - do not know if this is worth doing - place in `didTapSaveButton` if desired
    func checkIfRoutineExercisesAreUnique() {
        
        // get routine record's exercises
        // fetch all routines from core data - compare each of their exercises
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
            
            self?.dismiss?()
        }
    }
    
    
    func createRoutineAndSaveRoutineRecord() {
        
        print("validate all fields are entered")
        let routineRecord = routineRecordViewModel.mapToRoutineRecord(note: workoutNoteValue, completionDate: Date())
        
        guard allSetRecordsHaveValues(routineRecord: routineRecord) else {
            displaySaveError = true
            return
        }
        
        // Send the routine record to the new view, set up the name and any other information and then save it all on that view
        // dismiss all of the modals from there.
        print("Going to make the create routine appear")
        goToCreateRoutineView(routineRecord)
    }
    
    
    
    func deleteExerciseRecordPreliminary(for exerciseRecordViewModel: ExerciseRecordViewModel) {
        
        var inputtedDataForAtLeastOneSetRecordInExerciseRecord = false
        
        guard let indexToDelete = routineRecordViewModel.exerciseRecordViewModels.firstIndex(of: exerciseRecordViewModel) else { return }
        
        for setRecordViewModel in routineRecordViewModel.exerciseRecordViewModels[indexToDelete].setRecordViewModels {
            if !setRecordViewModel.weight.isEmpty || !setRecordViewModel.repCount.isEmpty {
                inputtedDataForAtLeastOneSetRecordInExerciseRecord = true
            }
        }
        
        if inputtedDataForAtLeastOneSetRecordInExerciseRecord {
            displayDeleteExerciseWarning = true
            deleteExerciseIndex = indexToDelete
        } else {
            routineRecordViewModel.deleteExerciseRecord(index: indexToDelete)
        }
    }
    
    
    func deleteExerciseRecordPreliminary(at index: Int) {
        
        var inputtedDataForAtLeastOneSetRecordInExerciseRecord = false
        for setRecordViewModel in routineRecordViewModel.exerciseRecordViewModels[index].setRecordViewModels {
            if !setRecordViewModel.weight.isEmpty || !setRecordViewModel.repCount.isEmpty {
                inputtedDataForAtLeastOneSetRecordInExerciseRecord = true
            }
        }
        
        if inputtedDataForAtLeastOneSetRecordInExerciseRecord {
            displayDeleteExerciseWarning = true
            deleteExerciseIndex = index
        } else {
            routineRecordViewModel.deleteExerciseRecord(index: index)
        }
    }
    
    
    func deleteExerciseRecordFromAlert() {
        
        guard let deleteExerciseIndex = deleteExerciseIndex else { return }
        
        var exerciseRecordViewModels = routineRecordViewModel.exerciseRecordViewModels
        exerciseRecordViewModels.remove(at: deleteExerciseIndex)
        
        routineRecordViewModel.exerciseRecordViewModels = exerciseRecordViewModels
        
        self.deleteExerciseIndex = nil
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
