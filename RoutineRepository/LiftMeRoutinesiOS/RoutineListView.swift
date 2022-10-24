//
//  RoutineListView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 10/23/22.
//

import RoutineRepository
import SwiftUI

public class RoutineViewModel: ObservableObject {
    
    let routineRepository: RoutineRepository
    
    // TODO: Could I make this a future instead since it should only be emitted once
    @Published var firstLoadCompleted = false
    @Published var routineLoadError = false
    @Published var routines = [Routine]()
    
    public init(routineRepository: RoutineRepository) {
        self.routineRepository = routineRepository
    }
    
    
    func loadRoutines() {
        routineRepository.loadAllRoutines { [weak self] result in
            
            if self?.firstLoadCompleted == false {
                self?.firstLoadCompleted = true
            }
            
            switch result {
            case let .success(routines):
                
                self?.routines = routines
                
            case .failure:
                self?.routineLoadError = true
            }
        }
    }
}


struct LowKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.universeRed)
    }
}


struct HighKeyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color(uiColor: .label))
            .padding(4)
            .padding(.horizontal, 6)
            .background(
                Capsule()
                    .fill(Color.universeRed)
            )
    }
}


public struct RoutineListView: View {
    
    public let inspection = Inspection<Self>()
    public let viewModel: RoutineViewModel
    
    public init(viewModel: RoutineViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .leading) {

            RoutineTitleBarView()
            
            ScrollableRoutineListView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadRoutines()
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}


public struct RoutineTitleBarView: View {
    
    public var body: some View {
        
        HStack {
            HStack(spacing: 16) {
                
                RoutineTitleView()
                
                NewRoutineButtonView()
            }
            
            Spacer()

            MoreRoutinesButtonView()
        }
    }
}


public struct RoutineTitleView: View {
    
    public var body: some View {
        Text("Routines")
            .font(.title2)
    }
}


public struct NewRoutineButtonView: View {
    
    public var body: some View {
        Button {
            print("hello world")
        } label: {
            HStack {
                Text("New")
                Image(systemName: "plus")
            }
        }
        .buttonStyle(HighKeyButtonStyle())
    }
}


public struct MoreRoutinesButtonView: View {
    
    public var body: some View {
        Button {
            print("hello world 2")
        } label: {
            HStack {
                Text("More")
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(LowKeyButtonStyle())
    }
}


public struct RoutineCellView: View {
    
    let routine: Routine
    
    public var body: some View {
        Text("\(routine.name)")
    }
}


public struct EmptyRoutineCellView: View {
    
    public var body: some View {
        Text("Aww shucks. No routines yet.")
    }
}


public struct ErrorRoutineCellView: View {
    
    public var body: some View {
        Text("Error loading routines... dang")
    }
}


public struct ScrollableRoutineListView: View {
    
    let viewModel: RoutineViewModel
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(spacing: 12) {
                
                if viewModel.firstLoadCompleted {
                    
                    if viewModel.routineLoadError {
                        ErrorRoutineCellView()
                    } else {
                        
                        if viewModel.routines.isEmpty {
                            EmptyRoutineCellView()
                            
                        } else {
                            
                            ForEach(viewModel.routines, id: \.self) { routine in
                                RoutineCellView(routine: routine)
                            }
                        }
                    }
                }
            }
            .padding(.leading)
            .frame(height: 160)
        }
        .background(Color.secondarySystemBackground)
    }
}

struct RoutineListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RoutineListView(
            viewModel: RoutineViewModel(
                routineRepository: RoutineRepositoryPreview()))
            .preferredColorScheme(.dark)
    }
}


class RoutineRepositoryPreview: RoutineRepository {
    
    func save(routine: Routine, completion: @escaping SaveRoutineCompletion) {
        completion(nil)
    }
    
    func loadAllRoutines(completion: @escaping LoadAllRoutinesCompletion) {
        completion(.success([]))
    }
}
