//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI

public struct CreateRoutineView: View {
    
    public init() {}
    
    public var body: some View {
        Text("Create Routine")
            .navigationTitle("1")
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        print("Dismiss view")
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
