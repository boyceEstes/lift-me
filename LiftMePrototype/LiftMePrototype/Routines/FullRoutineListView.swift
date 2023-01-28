//
//  FullRoutineListView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 1/2/23.
//

import SwiftUI

struct FullRoutineListView: View {
    
    let allRoutines: [String] = ["Back and Biceps 1", "Chest and Triceps - Powerlifting", "Pull Day", "Push Day"]
    var dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    
    var body: some View {
        List {
            ForEach(allRoutines, id: \.self) { routineName in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(routineName)
                        
                        HStack {
                            Text("Last completed: \(dateFormatter.string(from: Date()))")
//                            Spacer()
//                            Text("Completions: \(Int.random(in: 0..<10))")
                        }
                        .font(.caption)
                    }
                    
                    Spacer()
                    
                    Button {
                        print("Start")
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.universeRed)
                            .font(.system(.title3))
                    }.buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Routines")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RoutineListView4_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FullRoutineListView()
        }
    }
}
