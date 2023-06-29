//
//  RoutineCellView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI
import RoutineRepository

public struct RoutineCellView: View {
    
    let routine: Routine
    let goToWorkoutView: (Routine) -> Void
    
    public var body: some View {
        Text("\(routine.name)")
            .padding(.horizontal)
            .roundedCell()
            .onTapGesture {
                goToWorkoutView(routine)
            }
    }
}


public struct EmptyRoutineCellView: View {
    
    public var body: some View {
        Text("Aww shucks. No routines yet.")
            .padding(.horizontal)
            .roundedCell()
    }
}


public struct ErrorRoutineCellView: View {
    
    public var body: some View {
        
        Text("Error loading routines... dang")
            .padding(.horizontal)
            .roundedCell()
    }
}


struct RoutineCellView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineCellView(routine: Routine(id: UUID(), name: "Any Routine", creationDate: Date(), exercises: [], routineRecords: []), goToWorkoutView: { _ in })
        EmptyRoutineCellView()
        ErrorRoutineCellView()
    }
}
