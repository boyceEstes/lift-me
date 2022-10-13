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
                completion(.success(()))
            } catch {
                completion(.failure(error))
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
        
        let exp = expectation(description: "Wait for RoutineStore completion")
        sut.readAllRoutines() { result in
            
            switch result {
            case let .success(routines):
                XCTAssertEqual(routines, [])
                
            default:
                XCTFail("Expected empty results, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnEmptyCacheTwice_deliversNoSideEffects() {
        
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for RoutineStore completion")
        sut.readAllRoutines() { firstResult in
            
            sut.readAllRoutines { secondResult in
                switch (firstResult, secondResult) {
                case let (.success(firstRoutines), .success(secondRoutines)):
                    XCTAssertEqual(firstRoutines, [])
                    XCTAssertEqual(secondRoutines, [])
                    
                default:
                    XCTFail("Expected empty results, got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_coreDataRoutineStore_readRoutinesOnNonEmtpyCache_deliversCachedRoutines() {
        
        let sut = makeSUT()
        
        // TODO: Since we have not implmented ManagedExercises, this uniqueRotuine will have to not have any for now
        let routine = uniqueRoutine(exercises: []).local
        let exp = expectation(description: "Wait for RoutineStore completion")
        sut.create(routine) { firstResult in
            
            sut.readAllRoutines { secondResult in
                switch (firstResult, secondResult) {
                case let (.success, .success(receivedRoutines)):
                    XCTAssertEqual(receivedRoutines, [routine])
                    
                default:
                    XCTFail("Expected one success routine result, got \(firstResult) and \(secondResult) instead")
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
}

