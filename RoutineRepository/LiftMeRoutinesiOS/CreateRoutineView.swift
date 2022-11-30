//
//  CreateRoutineView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 11/11/22.
//

import SwiftUI

public struct CreateRoutineView: View {
    
    @State private var name = ""
    
    public init() {}
    
    public var body: some View {
        Form {
            TextField("Name", text: $name)
        }
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
