//
//  RoutineDetailView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/28/23.
//

import SwiftUI
import RoutineRepository

public struct RoutineDetailView: View {
    
    let routine: Routine
//    let goToAddExercise: () -> Void
    
    public init(routine: Routine) {
        self.routine = routine
    }
    
    public var body: some View {
        
        Form {
            Text("\(routine.name)")
            
            EditableExerciseSectionView(
                exercises: routine.exercises,
                goToAddExerciseView: { }
            )
        }
        .basicNavigationBar(title: "Routine Details")
    }
}


struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineDetailView(routine: Routine(id: UUID(), name: "Routine", creationDate: Date(), exercises: [], routineRecords: []))
    }
}
