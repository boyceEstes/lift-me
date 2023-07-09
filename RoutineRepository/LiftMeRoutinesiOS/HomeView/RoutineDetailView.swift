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
    
    let routine: Routine
    let goToAddExercise: (@escaping ([Exercise]) -> Void) -> Void
    
    let uuid = UUID()
    
    public init(
        routine: Routine,
        goToAddExercise: @escaping (@escaping ([Exercise]) -> Void) -> Void
    ) {
        
        self.routine = routine
        self.exercises = routine.exercises
        self.goToAddExercise = goToAddExercise
        print("BOYCE: DID MAKE ROUTINE DETAIL VIEW MODEL - \(uuid)")
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
                goToAddExercise: viewModel.goToAddExercise
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
            routine: Routine(id: UUID(), name: "Routine", creationDate: Date(), exercises: [], routineRecords: []),
            goToAddExercise: { _ in }
        )
        
        RoutineDetailView(
            viewModel: viewModel
        )
    }
}
