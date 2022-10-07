//
//  ExerciseListViewTests.swift
//  LiftMeiOSTests
//
//  Created by Boyce Estes on 8/23/22.
//

import XCTest
import SwiftUI
import ViewInspector
import ExerciseRepository

extension DateFormatter {
    
    static var mediumDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


class ExerciseListViewModel: ObservableObject {
    
    let exerciseRepository: ExerciseRepository
    
    @Published var exercises = [Exercise]()
    
    init(exerciseRepository: ExerciseRepository) {
        self.exerciseRepository = exerciseRepository
    }
    
    func loadExercises() {
        exerciseRepository.loadAllExercises { [weak self] result in
            if let receivedExercises = try? result.get() {
                self?.exercises = receivedExercises
            }
        }
    }
    
    func dateLastCompletedMessage(for exercise: Exercise) -> String {
        if let dateLastCompleted = exercise.dateLastCompleted {
            return "Last completed: \(DateFormatter.mediumDate.string(from: dateLastCompleted))"
        } else {
            return "No records found"
        }
    }
}

struct ExerciseListView: View {
    
    let viewModel: ExerciseListViewModel
    
    var didAppear: ((Self) -> Void)?
    
    var body: some View {
        List {
            ForEach(viewModel.exercises, id: \.self) { exercise in
                VStack {
                    Text(exercise.name)
                    Text(viewModel.dateLastCompletedMessage(for: exercise))
                }
            }
        }
        .onAppear {
            viewModel.loadExercises()
            self.didAppear?(self)
        }
    }
}


extension ExerciseListView: Inspectable { }

class ExerciseListViewTests: XCTestCase {
    
    
    func test_exerciseListView_loadExerciseRepository_makesRequestsFromRepository() {
        
        let (sut, exerciseRepository) = makeSut()
        XCTAssertEqual(exerciseRepository.requestCount, 0)
        
        host(sut)
        XCTAssertEqual(exerciseRepository.requestCount, 1)
    }
    
    
    func test_exerciseListView_successfullyLoadsExercises_rendersListOfExercises() throws {
        
        let (sut, exerciseRepository) = makeSut()
        
        host(sut)
        
        let exercises = makeUniqueExercisesTuple().models
        exerciseRepository.completeWith(exercises)
        
        try assertThat(sut, isRendering: exercises)
    }

    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: ExerciseListView, exerciseRepository: ExerciseRepositorySpy){
        
        let exerciseRepository = ExerciseRepositorySpy()
        let viewModel = ExerciseListViewModel(exerciseRepository: exerciseRepository)
        let sut = ExerciseListView(viewModel: viewModel)
        
        return (sut, exerciseRepository)
    }
    
    
    private func host(_ sut: ExerciseListView) {
        
        var sut = sut
        let exp = expectation(description: "Wait for ExerciseListView to appear")
        
        sut.didAppear = { _ in
            exp.fulfill()
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 1)
    }


    private func assertThat(_ sut: ExerciseListView, isRendering exercises: [Exercise], file: StaticString = #file, line: UInt = #line) throws {
        
        let viewModel = sut.viewModel
        
        XCTAssertEqual(viewModel.exercises.count, exercises.count)
        
        // check that there are correct rows in a list
        try exercises.enumerated().forEach { (index, exercise) in
            
            let renderedRowTitle = try sut.inspect().find(text: exercise.name).string()
            let renderedRowLastCompletedSubtitle = try sut.inspect().find(text: viewModel.dateLastCompletedMessage(for: exercise)).string()
            XCTAssertEqual(renderedRowTitle, exercise.name)
            XCTAssertEqual(renderedRowLastCompletedSubtitle, viewModel.dateLastCompletedMessage(for: exercise))
        }
    }
    
    
    class ExerciseRepositorySpy: ExerciseRepository {
        
        private(set) var requestCount = 0
        private(set) var requests = [LoadAllExercisesResult]()
        
        // Conform to protocol
        func save(exercise: Exercise, completion: @escaping SaveExerciseResult) {}
        func update(exercise: Exercise, with updatedExercise: Exercise, completion: @escaping UpdateExerciseResult) {}
        
        func loadAllExercises(completion: @escaping LoadAllExercisesResult) {
            requestCount += 1
            requests.append(completion)
        }
        
        func remove(exercise: Exercise, completion: @escaping RemoveExerciseResult) {}
        func save(exerciseRecord: ExerciseRecord, completion: @escaping SaveExerciseRecordResult) {}
        func loadAllExerciseRecords(completion: @escaping LoadAllExerciseRecordsResult) {}
        func remove(exerciseRecord: ExerciseRecord, completion: @escaping RemoveExerciseRecordResult) {}
        func save(setRecord: SetRecord, completion: @escaping SaveSetRecordResult) {}
        func update(setRecord: SetRecord, completion: @escaping UpdateSetRecordResult) {}
        func remove(setRecord: SetRecord, completion: @escaping RemoveSetRecordResult) {}
        
        
        func completeWith(_ exercises: [Exercise], at index: Int = 0) {
            requests[index](.success(exercises))
        }
    }
}



