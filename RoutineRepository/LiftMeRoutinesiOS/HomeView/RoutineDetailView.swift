//
//  RoutineDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/28/23.
//

import SwiftUI
import RoutineRepository


public class RoutineDetailViewModel: ObservableObject {
    
    @Published var exercises: [Exercise]
    
    let routineStore: RoutineStore
    let routine: Routine
    let goToAddExercise: (@escaping ([Exercise]) -> Void) -> Void
    
    let uuid = UUID()
    
    public init(
        routineStore: RoutineStore,
        routine: Routine,
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void
    ) {
        
        self.routineStore = routineStore
        self.routine = routine
        self.exercises = routine.exercises
        self.goToAddExercise = goToAddExercise
        print("BOYCE: DID MAKE ROUTINE DETAIL VIEW MODEL - \(uuid)")
    }
   
    func goToAddExercisesWithCompletionHandled() {
        
        goToAddExercise { addedExercises in
            print("Add exercise completion from routine detail")
        }
    }
}


public struct RoutineDetailView: View {
    
//    let goToWorkout: (Routine) -> Void
//    let goToExerciseDetail: (Exercise) -> Void
    
    @ObservedObject var viewModel: RoutineDetailViewModel
    
    
    public init(
        viewModel: RoutineDetailViewModel
    ) {
        self.viewModel = viewModel
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
            
            EditableExerciseSectionView(
                exercises: $viewModel.exercises,
                goToAddExercise: viewModel.goToAddExercisesWithCompletionHandled
            )
        })
        .basicNavigationBar(title: "Routine Details")
        .onReceive(viewModel.exercises.publisher, perform: { exercise in
            print("received: \(exercise)")
        })
    }
}


struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = RoutineDetailViewModel(
            routineStore: RoutineStorePreview(),
            routine: Routine(id: UUID(), name: "Routine", creationDate: Date(), exercises: [], routineRecords: []),
            goToAddExercise: { _ in }
        )
        
        RoutineDetailView(
            viewModel: viewModel
        )
    }
}
