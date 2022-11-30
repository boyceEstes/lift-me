//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI

public struct CreateRoutineView: View {
    
    @State private var name = ""
    @State private var routineDescription = ""
    
    public init() {}
    
    public var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Description", text: $routineDescription)
        }
            .navigationTitle("1")
        
            .toolbar {
                ToolbarItem {
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
            CreateRoutineView()
        }
    }
}
