//
//  RoutineRepositoryCacheIntegrationTests.swift
//  RoutineRepositoryCacheIntegrationTests
//
//  Created by Boyce Estes on 10/18/22.
//

import XCTest
import RoutineRepository

class RoutineRepositoryCacheIntegrationTests: XCTestCase {

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
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalRoutineRepository {
        let storeURL = specificTestStoreURL()
        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let routineStore = try! CoreDataRoutineStore(storeURL: storeURL, bundle: bundle)
        let localRoutineRepository = LocalRoutineRepository(routineStore: routineStore)
        return localRoutineRepository
    }
    
    
    private func specificTestStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
