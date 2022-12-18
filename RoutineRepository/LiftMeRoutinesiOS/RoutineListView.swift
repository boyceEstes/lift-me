//
//  RoutineListView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 10/23/22.
//

import RoutineRepository
import SwiftUI

public class RoutineListViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    let goToCreateRoutine: () -> Void
    
    // TODO: Could I make this a future instead since it should only be emitted once
    @Published var firstLoadCompleted = false
    @Published var routineLoadError = false
    @Published var routines = [Routine]()
    
    
    public init(routineStore: RoutineStore,
                goToCreateRoutine: @escaping () -> Void
    ) {
        self.routineStore = routineStore
        self.goToCreateRoutine = goToCreateRoutine
    }
    
    
    public func loadRoutines() {
        routineStore.readAllRoutines() { [weak self] result in
        
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
    
    
    func tappedNewButton() {
        goToCreateRoutine()
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


struct RoutineCell: ViewModifier {
    
    let cellHeight: CGFloat = 130
    
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(Color(uiColor: .label))
            .frame(width: cellHeight , height: cellHeight)
            .background(Color(uiColor: .tertiarySystemBackground))
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding(.vertical)
    }
}


extension View {
    
    func routineCell() -> some View {
        modifier(RoutineCell())
    }
}


public struct RoutineListView: View {
    
    public let inspection = Inspection<Self>()
    
    @ObservedObject var viewModel: RoutineListViewModel
    
    
    public init(
        viewModel: RoutineListViewModel) {
            
        self.viewModel = viewModel
    }
    
    
    public var body: some View {
        VStack(alignment: .leading) {

            RoutineTitleBarView(viewModel: viewModel)
            
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
    

    @ObservedObject var viewModel: RoutineListViewModel
    
    public var body: some View {
        
        HStack {
            HStack(spacing: 16) {
                
                RoutineTitleView()
                
                NewRoutineButtonView(
                    viewModel: viewModel
                )
            }
            
            Spacer()

            MoreRoutinesButtonView()
        }
        .padding(.horizontal)
    }
}


public struct RoutineTitleView: View {
    
    public var body: some View {
        Text("Routines")
            .font(.title2)
    }
}


public struct NewRoutineButtonView: View {
    
    @ObservedObject var viewModel: RoutineListViewModel
    
    public var body: some View {
        Button {
            viewModel.tappedNewButton()
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
            .routineCell()
    }
}


public struct EmptyRoutineCellView: View {
    
    public var body: some View {
        Text("Aww shucks. No routines yet.")
            .routineCell()
    }
}


public struct ErrorRoutineCellView: View {
    
    public var body: some View {
        
        Text("Error loading routines... dang")
            .routineCell()
    }
}


public struct ScrollableRoutineListView: View {
    
    @ObservedObject var viewModel: RoutineListViewModel
    
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
            viewModel: RoutineListViewModel(
                routineStore: RoutineStorePreview(),
                goToCreateRoutine: { }
            )
        )
        .preferredColorScheme(.dark)
    }
}


class RoutineStorePreview: RoutineStore {

    func createUniqueRoutine(_ routine: Routine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        completion(nil)
    }
    
    
    func readRoutines(with name: String, or exercises: [Exercise], completion: @escaping ReadRoutinesCompletion) {
        completion(.success([]))
    }
    
    
    func readAllRoutines(completion: @escaping ReadRoutinesCompletion) {
        
        let routine = Routine(
            id: UUID(),
            name: "Preview",
            creationDate: Date(),
            exercises: [],
            routineRecords: [])
        completion(.success([routine]))
    }

}
