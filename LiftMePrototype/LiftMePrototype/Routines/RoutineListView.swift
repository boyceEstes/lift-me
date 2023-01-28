//
//  RoutineListView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 10/14/22.
//

import SwiftUI


struct RoutineListView3: View {
    let routineNames: [String] = ["Back and Biceps 1", "Chest and Triceps - Powerlifting", "Pull Day", "Push Day"]
    let error = true
    
    @State private var showCreateRoutine = false

    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                HStack(spacing: 16) {
                    Text("Routines")
                        .font(.title2)
                        
                    Button {
                        showCreateRoutine = true
                        
                    } label: {
                        HStack {
                            Text("New")
                            Image(systemName: "plus")
                        }
                    }
                    .buttonStyle(HighKeyButtonStyle())
                    .fullScreenCover(isPresented: $showCreateRoutine) {
                        CreateRoutineView()
                            .environment(\.editMode, .constant(.active))
                    }
                }
                
                Spacer()
                
                Button {
                    print("hello world")
                } label: {
                    HStack {
                        Text("More")
                        Image(systemName: "chevron.right")
                    }
                }
                .buttonStyle(LowKeyButtonStyle())
            }
            .padding(.horizontal)
            .padding(.top)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        if !error {
                            if routineNames.isEmpty {
                                RoutineEmptyCellView()
                            } else {
                                ForEach(routineNames, id: \.self) { id in
                                    RoutineCellView3(routineName: "\(id)")
                                }
                            }
                        } else {
                            RoutineErrorCellView(error: NSError(domain: "Any Error", code: 0))
                        }
                    }
                    .padding(.leading)
                    .frame(height: 160)
            }
            .background(Color(uiColor: .tertiarySystemBackground))
        }
    }
}


struct RoutineErrorCellView: View {
    
//    let cellHeight: CGFloat = 130
    let error: Error
    
    var body: some View {
        Button {
            print("Retry")
        } label: {
            VStack(spacing: 8) {
                Text("Failed to Fetch Routines")
                    
//                Image(systemName: "arrow.clockwise")
//                    .imageScale(.large)
            }
            .padding()
            .foregroundColor(Color(uiColor: .label))
            .frame(maxWidth: 130, maxHeight: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding(.vertical)
        }
    }
}


struct RoutineEmptyCellView: View {
    
    let cellHeight: CGFloat = 130
    
    var body: some View {
        Button {
            print("Retry")
        } label: {
            VStack(spacing: 8) {
                Text("Aww shucks. No Routines yet")
                    
//                Image(systemName: "arrow.clockwise")
//                    .imageScale(.large)
            }
            .padding()
            .foregroundColor(Color(uiColor: .label))
            .frame(width: cellHeight , height: cellHeight)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding(.vertical)
        }
    }
}


struct RoutineCellView3: View {
    
    let cellHeight: CGFloat = 130
    let routineName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(routineName)")
                .frame(maxWidth: .infinity, maxHeight: cellHeight / 3 * 2)
                .font(.headline)
            
            HStack() {
                HStack(spacing:0) {
                    Image(systemName: "star.fill")
                    Image(systemName: "star")
                    Image(systemName: "star")
                }
                Text("(12)")
                    .font(.subheadline)
            }
            .font(.callout)
            .foregroundColor(Color(uiColor: .label))
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3, alignment: .leading)
            .background(Color.universeRed)
        }
        .foregroundColor(Color(uiColor: .label))
        .frame(width: cellHeight, height: cellHeight)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(.vertical)
    }
}


struct RoutineListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
