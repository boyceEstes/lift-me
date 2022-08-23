//
//  ExerciseListViewTests.swift
//  LiftMeiOSTests
//
//  Created by Boyce Estes on 8/23/22.
//

import XCTest
import SwiftUI


struct ExerciseListView: View {
    
    var body: some View {
        Text("Hello world")
    }
}


class ExerciseListViewTests: XCTestCase {
    
    func test_exerciseListView_exerciseRepositoryRequestsOnInit_isEmpty() {
        
        let exerciseRepository = ExerciseRepositorySpy()
        _ = ExerciseListView()
        
        // Tests the number of requests
        XCTAssertEqual(exerciseRepository.requestCount, 0)
    }
    
    
    class ExerciseRepositorySpy {
        
        private(set) var requestCount = 0
    }
}



