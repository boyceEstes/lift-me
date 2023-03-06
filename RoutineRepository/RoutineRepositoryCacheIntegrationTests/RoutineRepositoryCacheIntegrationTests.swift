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
    

    func test_localRoutineStore_emptyCache_deliversNoItems() {
        
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .success([]))
    }
    
    
    func test_localRoutineStore_saveAndLoadOnDifferentInstances_deliversSavedItems() {
        
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine = uniqueRoutine(exercises: []) // This does not take exercises in consideration

        XCTAssertNil(save(routine, on: sutToPerformSave))
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine]))
    }
    
    
    func test_localRoutineStore_saveAndSaveRoutineWithSameNameOnDifferentInstances_deliversSameNameError() {
        
        let sutToPerformSave1 = makeSUT()
        let sutToPerformSave2 = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine = uniqueRoutine(name: "AnyName", exercises: [])
        
        XCTAssertNil(save(routine, on: sutToPerformSave1))
        let saveError = save(routine, on: sutToPerformSave2)
        XCTAssertEqual(saveError as NSError?, CoreDataRoutineStore.Error.routineWithNameAlreadyExists as NSError, "Expected same name error, but got \(String(describing: saveError)) instead")
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine]))
    }
    
    
    func test_localRoutineStore_saveAndSaveRoutineWithNoMatchingRoutine_deliversBothSavedRoutinesOrderedByName() {
        
        let sutToPerformSave1 = makeSUT()
        let sutToPerformSave2 = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let routine1 = uniqueRoutine(name: "A name", exercises: [])
        let routine2 = uniqueRoutine(name: "B name", exercises: [])
        
        XCTAssertNil(save(routine1, on: sutToPerformSave1))
        XCTAssertNil(save(routine2, on: sutToPerformSave2))
        
        expect(sutToPerformLoad, toCompleteWith: .success([routine1, routine2]))
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RoutineStore {
        
        let storeURL = specificTestStoreURL()
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: storeURL, bundle: bundle)
//        let localRoutineRepository = LocalRoutineRepository(routineStore: routineStore)
        trackForMemoryLeaks(routineStore)
//        trackForMemoryLeaks(localRoutineRepository)
        return routineStore
    }
    
    
    @discardableResult
    private func save(_ routine: Routine, on sut: RoutineStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        
        let expSave = expectation(description: "Wait for save routine completion")
        
        var receivedError: Error?
        sut.createUniqueRoutine(routine) { error in
            receivedError = error
            expSave.fulfill()
        }

        wait(for: [expSave], timeout: 1)
        
        return receivedError
    }
    
    
    private func expect(_ sut: RoutineStore, toCompleteWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        XCTAssertEqual(sut.routineDataSource().routines.value, try? expectedResult.get(), file: file, line: line)
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


