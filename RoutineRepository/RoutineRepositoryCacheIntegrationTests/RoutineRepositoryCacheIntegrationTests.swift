//
//  RoutineRepositoryCacheIntegrationTests.swift
//  RoutineRepositoryCacheIntegrationTests
//
//  Created by Boyce Estes on 10/18/22.
//

import XCTest
import RoutineRepository

/*
 *
 * - Create Cache is Empty
 * - Save to Cache and Load to cache on different instances
 * - Save to Cache and Save duplicate exercise on different instance
 * - Save to Cache and Save unmatching exercise on different instance
 */

class RoutineRepositoryCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    

    func test_localRoutineRepository_emptyCache_deliversNoItems() {
        
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for loadAllRoutines completion")
        sut.loadAllRoutines { result in
            switch result {
            case let .success(routines):
                XCTAssertEqual(routines, [])
            default:
                XCTFail("Expected empty routines array to be returned, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_localRoutineRepository_saveAndLoadOnDifferentInstances_deliversSavedItems() {
        
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine = uniqueRoutine().model // This should fail bc a problem with the transference to ManagedExercise
        
        let expSave = expectation(description: "Wait for save routine completion")
        sutToPerformSave.save(routine: routine) { error in
            XCTAssertNil(error, "Expected no error saving, got \(error!) instead")
            expSave.fulfill()
        }
        wait(for: [expSave], timeout: 1)
        
        
        let expLoad = expectation(description: "Wait for loadAllRoutines completion")
        sutToPerformLoad.loadAllRoutines { result in
            switch result {
            case let .success(routines):
                XCTAssertEqual(routines, [])
            default:
                XCTFail("Expected empty routines array to be returned, got \(result) instead")
            }
            expLoad.fulfill()
        }
        wait(for: [expLoad], timeout: 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalRoutineRepository {
        
        let storeURL = specificTestStoreURL()
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: storeURL, bundle: bundle)
        let localRoutineRepository = LocalRoutineRepository(routineStore: routineStore)
        trackForMemoryLeaks(routineStore)
        trackForMemoryLeaks(localRoutineRepository)
        return localRoutineRepository
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
    
    
    private func specificTestStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}


