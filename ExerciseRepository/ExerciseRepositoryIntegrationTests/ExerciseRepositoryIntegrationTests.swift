//
//  ExerciseRepositoryIntegrationTests.swift
//  ExerciseRepositoryIntegrationTests
//
//  Created by Boyce Estes on 6/22/22.
//

import XCTest
import ExerciseRepository

class ExerciseRepositoryIntegrationTests: XCTestCase {

    func test_localExerciseRepository_creation_hasEmptyCache() {
        
        let sut = makeSut()
        
        sut.loadAllExercises { result in
            switch result {
            case .success(let exercises):
                XCTAssertTrue(exercises.isEmpty)
            default:
                XCTFail("Expected to successfully retrieve empty cache, got \(result) instead")
            }
        }
    }
    
    private func makeSut() -> LocalExerciseRepository {
        
        let storeBundle = Bundle(for: CoreDataExerciseStore.self)
        let storeURL = specificTestStoreURL()
        let exerciseStore = try! CoreDataExerciseStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalExerciseRepository(exerciseStore: exerciseStore)
        trackForMemoryLeaks(exerciseStore)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    
    private func specificTestStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
