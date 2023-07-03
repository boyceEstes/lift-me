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
            print("exercises didSet: \(exercises)")
        }
    }
    
    let routine: Routine
    let uuid = UUID()
    
    public init(routine: Routine) {
        
        self.routine = routine
        self.exercises = routine.exercises
        print("BOYCE: DID MAKE ROUTINE DETAIL VIEW MODEL - \(uuid)")
    }
    
    // Passed to AddExerciseViewModel for logic after Add button is tapped
    public func addExercisesCompletion(exercises: [Exercise]) {
//
//        exercises.forEach { [weak self] in
//
//            print("Appending \($0.name)")
//            self?.exercises.append($0)
//        }
        
        self.exercises.append(contentsOf: exercises)
        print("Added exercises to routine detail: **\(uuid)**")
//        print("exercises: \(self.exercises)")
    }
}


public struct RoutineDetailView: View {
    
    let goToAddExercise: () -> Void
//    let goToWorkout: (Routine) -> Void
//    let goToExerciseDetail: (Exercise) -> Void
    
    @ObservedObject var viewModel: RoutineDetailViewModel
    
    
    public init(
        viewModel: RoutineDetailViewModel,
        // We need this here because the add exercise completion method is needed
        goToAddExercise: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.goToAddExercise = goToAddExercise
    }
    
    
    public var body: some View {
        
        Form {
            Text("\(viewModel.routine.name)")
            HStack {
                Text("UUID")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                Text("\(viewModel.uuid)")
            }
            
            EditableExerciseSectionView(
                exercises: viewModel.exercises,
                goToAddExerciseView: goToAddExercise
            )
            
        }
        .basicNavigationBar(title: "Routine Details")
        .onReceive(viewModel.exercises.publisher, perform: { exercise in
            print("received: \(exercise)")
        })
    }
}


struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = RoutineDetailViewModel(routine: Routine(id: UUID(), name: "Routine", creationDate: Date(), exercises: [], routineRecords: []))
        
        RoutineDetailView(
            viewModel: viewModel,
            goToAddExercise: { }
        )
    }
}
