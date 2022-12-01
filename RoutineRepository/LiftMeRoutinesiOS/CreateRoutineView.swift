//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI
import RoutineRepository

public struct CreateRoutineView: View {
    
    @State private var name = ""
    @State private var routineDescription = ""
    let routineRepository: RoutineRepository
    
    
    public init(routineRepository: RoutineRepository) {
        
        self.routineRepository = routineRepository
    }
    
    
    public var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Description", text: $routineDescription)
        }
            .navigationTitle("Create Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        print("Dismiss view")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        print("Save view")
                    }
                }
            }
    }
}

struct CreateRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateRoutineView(routineRepository: RoutineRepositoryPreview())
        }
    }
}
