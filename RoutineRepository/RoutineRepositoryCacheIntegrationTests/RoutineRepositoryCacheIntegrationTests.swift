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
 * - [x] Create Cache is Empty
 * - [x] Save to Cache and Load to cache on different instances
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
        
        expect(sut, toCompleteWith: .success([]))
    }
    
    
    func test_localRoutineRepository_saveAndLoadOnDifferentInstances_deliversSavedItems() {
        
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine = uniqueRoutine(exercises: []).model // This does not take exercises in consideration

        save(routine, on: sutToPerformSave)
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine]))

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
    
    
    private func save(_ routine: Routine, on sut: LocalRoutineRepository, file: StaticString = #file, line: UInt = #line) {
        
        let expSave = expectation(description: "Wait for save routine completion")
        
        sut.save(routine: routine) { error in
            XCTAssertNil(error, "Expected no error saving, got \(error!) instead")
            expSave.fulfill()
        }
        
        wait(for: [expSave], timeout: 1)
    }
    
    
    private func expect(_ sut: LocalRoutineRepository, toCompleteWith expectedResult: RoutineRepository.LoadAllRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        let expLoad = expectation(description: "Wait for loadAllRoutines completion")
        
        sut.loadAllRoutines { result in
            switch (result, expectedResult) {
            case let (.success(routines), .success(expectedRoutines)):
                XCTAssertEqual(routines, expectedRoutines)
                
            default:
                XCTFail("Expected \(expectedResult) to be returned, got \(result) instead")
            }
            expLoad.fulfill()
        }
        
        wait(for: [expLoad], timeout: 1)
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


