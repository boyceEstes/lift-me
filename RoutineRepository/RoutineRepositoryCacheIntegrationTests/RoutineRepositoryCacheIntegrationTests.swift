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
 * - [x] Save to Cache and Save duplicate routine on different instance
 * - [x] Save to Cache and Save unmatching exercise on different instance
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

        XCTAssertNil(save(routine, on: sutToPerformSave))
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine]))
    }
    
    
    func test_localRoutineRepository_saveAndSaveRoutineWithSameNameOnDifferentInstances_deliversSameNameError() {
        
        let sutToPerformSave1 = makeSUT()
        let sutToPerformSave2 = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine = uniqueRoutine(name: "AnyName", exercises: []).model
        
        XCTAssertNil(save(routine, on: sutToPerformSave1))
        XCTAssertEqual(save(routine, on: sutToPerformSave2) as NSError?, LocalRoutineRepository.Error.routineWithNameAlreadyExists as NSError)
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine]))
    }
    
    
    func test_localRoutineRepository_saveAndSaveRoutineWithNoMatchingRoutine_deliversBothSavedRoutines() {
        
        let sutToPerformSave1 = makeSUT()
        let sutToPerformSave2 = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine1 = uniqueRoutine(exercises: []).model
        let routine2 = uniqueRoutine(exercises: []).model
        
        XCTAssertNil(save(routine1, on: sutToPerformSave1))
        XCTAssertNil(save(routine2, on: sutToPerformSave2))
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine1, routine2]))
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
    
    
    @discardableResult
    private func save(_ routine: Routine, on sut: LocalRoutineRepository, file: StaticString = #file, line: UInt = #line) -> Error? {
        
        let expSave = expectation(description: "Wait for save routine completion")
        
        var receivedError: Error?
        sut.save(routine: routine) { error in
            receivedError = error
            expSave.fulfill()
        }
        
        wait(for: [expSave], timeout: 1)
        
        return receivedError
    }
    
    
    private func expect(_ sut: LocalRoutineRepository, toCompleteWith expectedResult: RoutineRepository.LoadAllRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        let expLoad = expectation(description: "Wait for loadAllRoutines completion")
        
        sut.loadAllRoutines { result in
            switch (result, expectedResult) {
            case let (.success(routines), .success(expectedRoutines)):
                XCTAssertEqual(routines, expectedRoutines, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult) to be returned, got \(result) instead", file: file, line: line)
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


