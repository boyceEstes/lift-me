//
//  CoreDataRoutineStoreTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/11/22.
//

import XCTest
import RoutineRepository


class CoreDataRoutineStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(name: "RoutineStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    // Any and all functions that you want
    func readAllRoutines(completion: @escaping RoutineStore.ReadRoutinesCompletion) {
        
        let context = context
        context.perform {
            do {
                let routines = try ManagedRoutine.findRoutines(in: context).toLocal()
                completion(.success(routines))
            } catch {
                completion(.success([]))
            }
        }
    }
    
    
    func create(_ routine: LocalRoutine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        let context = context
        context.perform {
            do {
                ManagedRoutine.create(routine, in: context)
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }

    }
}


private extension Array where Element == ManagedRoutine {
    func toLocal() -> [LocalRoutine] {
        map { $0.toLocal() }
    }
}


private extension ManagedRoutine {
    
    func toLocal() -> LocalRoutine {
        LocalRoutine(
            id: self.id,
            name: self.name,
            creationDate: self.creationDate,
            exercises: [],
            routineRecords: self.routineRecords.toLocal())
    }
}


private extension Set where Element == ManagedRoutineRecord {
    func toLocal() -> [LocalRoutineRecord] {
        map {
            LocalRoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: [])
        }
    }
}




private extension NSPersistentContainer {
    
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStores(Error)
    }
    
    static func load(name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        
        let description = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [description]
        
        var loadingError: Error?
        container.loadPersistentStores { loadingError = $1 }
        try loadingError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
        return container
    }
}


private extension NSManagedObjectModel {
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { url in
                NSManagedObjectModel(contentsOf: url)
            }
    }
}


class CoreDataRoutineStoreTests: XCTestCase {
    
    func test_coreDataRoutineStore_readRoutinesOnEmptyCache_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnEmptyCacheTwice_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        expect(sut, toCompleteTwiceWith: .success([]))
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnNonEmtpyCache_deliversCachedRoutines() {
        
        let sut = makeSUT()
        
        // TODO: Since we have not implmented ManagedExercises, this uniqueRotuine will have to not have any for now
        let routine = uniqueRoutine(exercises: []).local
        let exp = expectation(description: "Wait for RoutineStore completion")
        sut.create(routine) { firstResult in
            XCTAssertNil(firstResult)
            
            sut.readAllRoutines { secondResult in
                switch secondResult {
                case let .success(receivedRoutines):
                    XCTAssertEqual(receivedRoutines, [routine])
                    
                default:
                    XCTFail("Expected one success routine result, got \(String(describing: firstResult)) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        
        wait(for: [exp], timeout: 1)
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataRoutineStore {

        let bundle = Bundle(for: CoreDataRoutineStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataRoutineStore(storeURL: storeURL, bundle: bundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
    private func create(_ routine: LocalRoutine, into sut: CoreDataRoutineStore, file: StaticString = #file, line: UInt = #line) -> RoutineStore.CreateRoutineResult {
        
        let exp = expectation(description: "Wait for RoutineStore create completion")
        
        var receivedResult: RoutineStore.CreateRoutineResult = nil
        
        sut.create(routine) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedResult
    }
    
    
    private func expect(_ sut: CoreDataRoutineStore, toCompleteWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        
        let exp = expectation(description: "Wait for RoutineStore read completion")
        
        sut.readAllRoutines() { result in
            
            switch (result, expectedResult) {
            case let (.success(routines), .success(expectedRoutines)):
                XCTAssertEqual(routines, expectedRoutines, "Expected \(expectedRoutines) but got \(routines) instead", file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func expect(_ sut: CoreDataRoutineStore, toCompleteTwiceWith expectedResult: RoutineStore.ReadRoutinesResult, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toCompleteWith: expectedResult, file: file, line: line)
        expect(sut, toCompleteWith: expectedResult, file: file, line: line)
    }
}

