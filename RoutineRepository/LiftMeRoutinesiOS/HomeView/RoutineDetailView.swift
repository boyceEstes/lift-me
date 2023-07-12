//
//  RoutineDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/28/23.
//

import SwiftUI
import RoutineRepository


public class RoutineDetailViewModel: ObservableObject {
    
    @Published var exercises: [Exercise] {
        didSet {
            print("changed exercises to: \(exercises)")
        }
    }
    
    let routineStore: RoutineStore
    let routine: Routine
    let goToAddExercise: (@escaping ([Exercise]) -> Void) -> Void
    let goToWorkout: (Routine) -> Void
    let goToExerciseDetail: (Exercise) -> Void
    
    let uuid = UUID()
    
    public init(
        routineStore: RoutineStore,
        routine: Routine,
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToWorkout: @escaping (Routine) -> Void,
        goToExerciseDetail: @escaping (Exercise) -> Void
    ) {
        
        self.routineStore = routineStore
        self.routine = routine
        self.exercises = routine.exercises
        self.goToAddExercise = goToAddExercise
        self.goToWorkout = goToWorkout
        self.goToExerciseDetail = goToExerciseDetail
        print("BOYCE: DID MAKE ROUTINE DETAIL VIEW MODEL - \(uuid)")
    }
    
   
    func goToAddExercisesWithCompletionHandled() {
        print("goToAddExercisesWithCompletionHandled")
        
        goToAddExercise { [weak self] addedExercises in
            
            var updatedExercises: [Exercise]? = self?.exercises
            updatedExercises?.append(contentsOf: addedExercises)
            self?.updateRoutine(exercises: updatedExercises)
        }
    }
    
    
    private func updateRoutine(name: String? = nil, exercises: [Exercise]? = nil) {
        
        guard name != nil || exercises != nil else { return }
        
        let updatedRoutine = Routine(
            id: routine.id,
            name: name ?? routine.name,
            creationDate: routine.creationDate,
            exercises: exercises ?? routine.exercises,
            routineRecords: routine.routineRecords
        )
        
        routineStore.updateRoutine(
            with: routine.id,
            updatedRoutine: updatedRoutine
        ) { [weak self] error in
            
            guard error == nil else {
                fatalError("handle error \(error!)")
            }
            
            self?.reloadRoutine()
        }
    }
    
    
    private func reloadRoutine() {
        
        routineStore.readRoutine(with: routine.id) { [weak self] result in
            switch result {
            case let .success(latestRoutine):
                self?.exercises = latestRoutine.exercises
                
            case let .failure(error):
                fatalError("handle error - \(error)")
            }
        }
    }
}


public struct RoutineDetailView: View {
    
    @StateObject var viewModel: RoutineDetailViewModel
    
    
    public init(
        routineStore: RoutineStore,
        routine: Routine,
        goToAddExerciseFromRoutineDetail: @escaping (@escaping ([Exercise]) -> Void) -> Void,
        goToWorkout: @escaping (Routine) -> Void,
        goToExerciseDetail: @escaping (Exercise) -> Void
    ) {
        self._viewModel = StateObject(
            wrappedValue: RoutineDetailViewModel(
                routineStore: routineStore,
                routine: routine,
                goToAddExercise: goToAddExerciseFromRoutineDetail,
                goToWorkout: goToWorkout,
                goToExerciseDetail: goToExerciseDetail
            )
        )
    }
    
    
    public var body: some View {
        
        Form(content: {
            Text("\(viewModel.routine.name)")
            HStack {
                Text("UUID")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                Text("\(viewModel.uuid)")
            }
            
            Button("Start Routine") {
                viewModel.goToWorkout(viewModel.routine)
            }
            .buttonStyle(LongHighKeyButtonStyle())
            .buttonStyle(BorderlessButtonStyle())
            
            
            EditableExerciseSectionView(
                exercises: $viewModel.exercises,
                goToAddExercise: viewModel.goToAddExercisesWithCompletionHandled,
                goToExerciseDetail: viewModel.goToExerciseDetail
            )
        })
        .basicNavigationBar(title: "Routine Details")
    }
}


struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        RoutineDetailView(
            routineStore: RoutineStorePreview(),
            routine: Routine(id: UUID(), name: "Routine", creationDate: Date(), exercises: [], routineRecords: []),
            goToAddExerciseFromRoutineDetail: { _ in },
            goToWorkout: { _ in },
            goToExerciseDetail: { _ in }
        )
    }
}
