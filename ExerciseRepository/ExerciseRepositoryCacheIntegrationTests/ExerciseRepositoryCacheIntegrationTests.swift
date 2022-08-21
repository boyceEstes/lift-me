//
//  ExerciseRepositoryIntegrationTests.swift
//  ExerciseRepositoryCacheIntegrationTests
//
//  Created by Boyce Estes on 6/22/22.
//

import XCTest
import ExerciseRepository

class ExerciseRepositoryIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }


    override func tearDown() {
        
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    
    func test_localExerciseRepository_creation_hasEmptyCache() {
        
        let sut = makeSut()
        
        expect(sut, toCompleteWith: [])
    }
    

    func test_localExerciseRepository_saveOnSeparateInstance_deliversExercises() {
        
        let sutToPerformSave = makeSut()
        let sutToPerformSave2 = makeSut()
        let sutToPerformLoad = makeSut()
        
        let exercise1 = makeUniqueExerciseTuple().model
        let exercise2 = makeUniqueExerciseTuple().model
        
        save(exercise1, with: sutToPerformSave)
        save(exercise2, with: sutToPerformSave2)
        
        expect(sutToPerformLoad, toCompleteWith: [exercise1, exercise2])
    }


    // MARK: - Helpers
    private func makeSut() -> LocalExerciseRepository {
        
        let storeBundle = Bundle(for: CoreDataExerciseStore.self)
        let storeURL = specificTestStoreURL()
        let exerciseStore = try! CoreDataExerciseStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalExerciseRepository(exerciseStore: exerciseStore)
        trackForMemoryLeaks(exerciseStore)
        trackForMemoryLeaks(sut)
        return sut
    }


    private func expect(_ sut: LocalExerciseRepository, toCompleteWith expectedExercises: [Exercise], file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for exercises to load")
        
        sut.loadAllExercises { result in
            
            switch result {
            case let .success(receivedExercises):
                XCTAssertEqual(receivedExercises, expectedExercises, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful exercises as result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }


    private func save(_ exercise: Exercise, with sut: LocalExerciseRepository, file: StaticString = #file, line: UInt = #line) {
        
        let saveExp = expectation(description: "Wait for save exercise completion")
        sut.save(exercise: exercise) { error in
            
            if error != nil {
                XCTFail("Expected no error, but got \(error!) instead", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1)
    }


    private func specificTestStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }


    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
        
    }
    
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: specificTestStoreURL())
    }
}
