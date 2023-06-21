//
//  RoutineListView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 10/23/22.
//

import RoutineRepository
import SwiftUI
import Combine



public class RoutineListViewModel: ObservableObject {
    
    let routineStore: RoutineStore
    let routineDataSource: RoutineDataSource
    let goToCreateRoutine: () -> Void
    let goToWorkoutView: (Routine) -> Void
    
//    let routineUIDataSource: RoutineDataSource
    
    // TODO: Could I make this a future instead since it should only be emitted once
//    @Published var firstLoadCompleted = false
    @Published var routineLoadingError = false
    @Published var routines = [Routine]()
    
    var cancellables = Set<AnyCancellable>()
    
    
    public init(
        routineStore: RoutineStore,
        goToCreateRoutine: @escaping () -> Void,
        goToWorkoutView: @escaping (Routine) -> Void
    ) {
        self.routineStore = routineStore
        self.goToCreateRoutine = goToCreateRoutine
        self.goToWorkoutView = goToWorkoutView
        
        self.routineDataSource = routineStore.routineDataSource()
        bindDataSource()
    }
    
    
    func bindDataSource() {
        
        routineDataSource.routines
            .sink { [weak self] error in
            print("BOYCE: 2 Error")
            self?.routineLoadingError = true
                
        } receiveValue: { [weak self] routines in
            
            self?.routines = routines
            
        }.store(in: &cancellables)
    }

    
    func tappedNewButton() {
        goToCreateRoutine()
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
//        .onAppear {
//            viewModel.loadRoutines()
//        }
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
    let goToWorkoutView: (Routine) -> Void
    
    public var body: some View {
        Text("\(routine.name)")
            .routineCell()
            .onTapGesture {
                goToWorkoutView(routine)
            }
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
                
//                if viewModel.firstLoadCompleted {
                    
                    if viewModel.routineLoadingError {
                        ErrorRoutineCellView()
                    } else {
                        
                        if viewModel.routines.isEmpty {
                            EmptyRoutineCellView()
                            
                        } else {
                            
                            ForEach(viewModel.routines, id: \.self) { routine in
                                RoutineCellView(
                                    routine: routine,
                                    goToWorkoutView: viewModel.goToWorkoutView)
                            }
                        }
                    }
//                }
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
                goToCreateRoutine: { },
                goToWorkoutView: { _ in }
            )
        )
//        .preferredColorScheme(.dark)
    }
}
