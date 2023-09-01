//
//  WorkoutView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 1/11/23.
//

import SwiftUI
import RoutineRepository


public struct WorkoutView: View {
    
    public let inspection = Inspection<Self>()
    
    @Environment(\.dismiss) private var dismiss
    @StateObject public var viewModel: WorkoutViewModel
    
    // Moving
    @GestureState var press = false
    @State private var draggedExerciseRecordViewModel: ExerciseRecordViewModel?
    

    public init(
        routineStore: RoutineStore,
        routine: Routine? = nil,
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToCreateRoutineView: @escaping (RoutineRecord) -> Void
    ) {
        
        self._viewModel = StateObject(
            wrappedValue: WorkoutViewModel(
                routineStore: routineStore,
                routine: routine,
                goToAddExercise: goToAddExercise,
                goToCreateRoutineView: goToCreateRoutineView
            )
        )
    }
    
    
    public var body: some View {
            
        ScrollView {
            LazyVStack(spacing: 20) {

                workoutNote

                exerciseContent

                addExerciseButton
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemGroupedBackground), ignoresSafeAreaEdges: .all)
        .onAppear {
            viewModel.dismiss = dismiss.callAsFunction
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
        .alert("Are you sure?", isPresented: $viewModel.displayDeleteExerciseWarning, actions: {
            Button("Yes", role: .destructive) {
                viewModel.deleteExerciseRecordFromAlert()
            }
            Button("No", role: .cancel) {
                print("No")
            }
        }, message: {
            Text("You have set content logged. Are you sure you want to delete this exercise?")
        })
        .basicNavigationBar {
            VStack {
                Text("Workout")
                    .font(.headline)
                StopwatchHHmmssView(startDate: viewModel.startDate)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.didTapSaveButton()
                }
                .disabled(viewModel.isSaveDisabled)
            }
        }
    }
    
    
    var workoutNote: some View {
        EditableNoteSectionView(buttonState: $viewModel.workoutNoteState, note: $viewModel.workoutNoteValue)
            .padding(.horizontal)
    }
    
    
    @ViewBuilder
    var exerciseContent: some View {
        
        if viewModel.routineRecordViewModel.exerciseRecordViewModels.isEmpty {
            Text("Try adding an exercise!")
        } else {
            ForEach($viewModel.routineRecordViewModel.exerciseRecordViewModels) { $exerciseRecordViewModel in
                
                ExerciseRecordView(
                    exerciseRecordViewModel: $exerciseRecordViewModel,
                    deleteExerciseAction: {
                        viewModel.deleteExerciseRecordPreliminary(for: $exerciseRecordViewModel.wrappedValue)
                    }
                )
                .onDrag {
                    self.draggedExerciseRecordViewModel = exerciseRecordViewModel
                    return NSItemProvider()
                }
                .onDrop(
                    of: [.text],
                    delegate: ExerciseDropDelegate(
                        destinationExerciseRecordViewModel: $exerciseRecordViewModel.wrappedValue,
                        exerciseRecordViewModels: $viewModel.routineRecordViewModel.exerciseRecordViewModels,
                        draggedExerciseRecordViewModel: $draggedExerciseRecordViewModel
                    )
                )
            }
            .padding(.horizontal)
        }
    }
    
    
    var addExerciseButton: some View {
        
        Button {
            print("Tapped button to go to Add Exercise from view-model(\(viewModel.uuid.uuidString))")
            viewModel.goToAddExercise( { exercises in
                withAnimation {
                    viewModel.addExercisesCompletion(exercises: exercises)
                }
            })
        } label: {
            HStack {
                Text("Add")
                Image(systemName: "plus")
            }
        }
        .buttonStyle(HighKeyButtonStyle())
        .id("add-exercise-button")
    }
}


struct WorkoutView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        
        NavigationStack {
            WorkoutView(
                routineStore: RoutineStorePreview(),
                goToAddExercise: { _ in },
                goToCreateRoutineView: { _ in }
            )
        }
        
        
    }
}
