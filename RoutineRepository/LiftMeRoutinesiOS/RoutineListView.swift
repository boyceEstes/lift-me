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
    let goToRoutineDetail: (Routine) -> Void
    
    //    let routineUIDataSource: RoutineDataSource
    
    // TODO: Could I make this a future instead since it should only be emitted once
    //    @Published var firstLoadCompleted = false
    @Published var routineLoadingError = false
    @Published var routines = [Routine]()
    
    var cancellables = Set<AnyCancellable>()
    
    
    public init(
        routineStore: RoutineStore,
        goToCreateRoutine: @escaping () -> Void,
        goToRoutineDetail: @escaping (Routine) -> Void
    ) {
        self.routineStore = routineStore
        self.goToCreateRoutine = goToCreateRoutine
        self.goToRoutineDetail = goToRoutineDetail
        
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


public struct RoutineListView: View {
    
    public let inspection = Inspection<Self>()
    
    @StateObject var viewModel: RoutineListViewModel
    
    
    public init(
        routineStore: RoutineStore,
        goToCreateRoutine: @escaping () -> Void,
        goToRoutineDetail: @escaping (Routine) -> Void
    ) {
        
        self._viewModel = StateObject(
            wrappedValue: RoutineListViewModel(
                routineStore: routineStore,
                goToCreateRoutine: goToCreateRoutine,
                goToRoutineDetail: goToRoutineDetail
            )
        )
    }
    
    
    public var body: some View {
        VStack(alignment: .leading) {
            
            RoutineTitleBarView(viewModel: viewModel)
            
            ScrollableRoutineListView(viewModel: viewModel)
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


public struct ScrollableRoutineListView: View {
    
    @ObservedObject var viewModel: RoutineListViewModel
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(spacing: 12) {
                
                if viewModel.routineLoadingError {
                    ErrorRoutineCellView()
                } else {
                    
                    if viewModel.routines.isEmpty {
                        EmptyRoutineCellView()
                        
                    } else {
                        
                        ForEach(viewModel.routines, id: \.self) { routine in
                            RoutineCellView(
                                routine: routine,
                                goToRoutineDetail: viewModel.goToRoutineDetail
                            )
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
            routineStore: RoutineStorePreview(),
            goToCreateRoutine: { },
            goToRoutineDetail: { _ in }
        )
        //        .preferredColorScheme(.dark)
    }
}
