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


struct ExerciseListView: View {
    
    let exerciseRepository: ExerciseRepository
    var didAppear: ((Self) -> Void)?
    
    var body: some View {
        Text("Hello world")
            .onAppear {
                self.exerciseRepository.loadAllExercises { _ in }
                self.didAppear?(self)
            }
    }
}


extension ExerciseListView: Inspectable { }

class ExerciseListViewTests: XCTestCase {
    
    
    func test_exerciseListView_loadExerciseRepository_makesRequestsFromRepository() {
        
        let exerciseRepository = ExerciseRepositorySpy()
        var sut = ExerciseListView(exerciseRepository: exerciseRepository)
        
        XCTAssertEqual(exerciseRepository.requestCount, 0)
        
        let exp = expectation(description: "Wait for ExerciseListView to appear")
        
        sut.didAppear = { _ in
            XCTAssertEqual(exerciseRepository.requestCount, 1)
            exp.fulfill()
        }
        
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 1)
    }

    
    class ExerciseRepositorySpy: ExerciseRepository {
        
        private(set) var requestCount = 0
        
        // Conform to protocol
        func save(exercise: Exercise, completion: @escaping SaveExerciseResult) {}
        func update(exercise: Exercise, with updatedExercise: Exercise, completion: @escaping UpdateExerciseResult) {}
        
        func loadAllExercises(completion: @escaping LoadAllExercisesResult) {
            requestCount += 1
        }
        
        func remove(exercise: Exercise, completion: @escaping RemoveExerciseResult) {}
        func save(exerciseRecord: ExerciseRecord, completion: @escaping SaveExerciseRecordResult) {}
        func loadAllExerciseRecords(completion: @escaping LoadAllExerciseRecordsResult) {}
        func remove(exerciseRecord: ExerciseRecord, completion: @escaping RemoveExerciseRecordResult) {}
        func save(setRecord: SetRecord, completion: @escaping SaveSetRecordResult) {}
        func update(setRecord: SetRecord, completion: @escaping UpdateSetRecordResult) {}
        func remove(setRecord: SetRecord, completion: @escaping RemoveSetRecordResult) {}
    }
}



