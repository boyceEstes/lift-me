//
//  SaveRoutineUseCaseTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/8/22.
//

import XCTest
import RoutineRepository


struct LocalRoutine: Equatable {
    
    let id: UUID
    let name: String
    let creationDate: Date
    
    // relationships
    let exercises: [LocalExercise]
    let routineRecords: [LocalRoutineRecord]
}

struct LocalRoutineRecord: Equatable {
    
    let id: UUID
    let creationDate: Date
    let completionDate: Date?
    
    // relationships
    let exerciseRecords: [LocalExerciseRecord]
}

struct LocalExercise: Equatable {
    
    let id: UUID
    let name: String
    let creationDate: Date
    
    // relationships
    let exerciseRecords: [LocalExerciseRecord]
    let tags: [LocalTag]
}

struct LocalExerciseRecord: Equatable {
    
    let id: UUID
    
    // relationships
    let setRecords: [LocalSetRecord]
}

struct LocalSetRecord: Equatable {
    
    let id: UUID
    let duration: Int?
    let repCount: Int?
    let weight: Int
    let difficulty: Int
}

struct LocalTag: Equatable {
    
    let id: UUID
    let name: String
}




private extension Routine {
    
    func toLocal() -> LocalRoutine {
        return LocalRoutine(
            id: self.id,
            name: self.name,
            creationDate: self.creationDate,
            exercises: self.exercises.toLocal(),
            routineRecords: self.routineRecords.toLocal())
    }
}

private extension Array where Element == Exercise {
    
    func toLocal() -> [LocalExercise] {
        return map {
            LocalExercise(
                id: $0.id,
                name: $0.name,
                creationDate: $0.creationDate,
                exerciseRecords: $0.exerciseRecords.toLocal(),
                tags: $0.tags.toLocal())
        }
    }
}

private extension Array where Element == ExerciseRecord {
    
    func toLocal() -> [LocalExerciseRecord] {
        return map {
            LocalExerciseRecord(
                id: $0.id,
                setRecords: $0.setRecords.toLocal())
        }
    }
}

private extension Array where Element == SetRecord {
    
    func toLocal() -> [LocalSetRecord] {
        return map {
            LocalSetRecord(
                id: $0.id,
                duration: $0.duration,
                repCount: $0.repCount,
                weight: $0.weight,
                difficulty: $0.difficulty)
        }
    }
}

private extension Array where Element == Tag {
    
    func toLocal() -> [LocalTag] {
        return map {
            LocalTag(id: $0.id, name: $0.name)
        }
    }
}

private extension Array where Element == RoutineRecord {
    
    func toLocal() -> [LocalRoutineRecord] {
        return map {
            LocalRoutineRecord(
                id: $0.id,
                creationDate: $0.creationDate,
                completionDate: $0.completionDate,
                exerciseRecords: $0.exerciseRecords.toLocal())
        }
    }
}



protocol RoutineStore {
    
    typealias ReadRoutineResult = Result<[LocalRoutine], Error>
    
    typealias ReadRoutineCompletion = (ReadRoutineResult) -> Void
    
    func create(_ routine: LocalRoutine)
    // fetch routines with the given name or exercises
    func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping ReadRoutineCompletion)
}


class RoutineStoreSpy: RoutineStore {

    enum ReceivedMessage: Equatable {
        case createRoutine(LocalRoutine)
        case readRoutines(name: String, exercises: [LocalExercise])
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private(set) var readRoutineCompletions = [RoutineStore.ReadRoutineCompletion]()
    
    init() {}
    
    // Conformance to RoutineStore
    func create(_ routine: LocalRoutine) {
        
        receivedMessages.append(.createRoutine(routine))
    }
    
    
    func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping RoutineStore.ReadRoutineCompletion) {
        
        receivedMessages.append(.readRoutines(name: name, exercises: exercises))
        readRoutineCompletions.append(completion)
    }
    
    // Spy work 🕵🏼‍♂️
    func completeReadRoutines(with routines: [LocalRoutine], at index: Int = 0) {
        readRoutineCompletions[index](.success(routines))
    }
}


class LocalRoutineRepository: RoutineRepository {
    
    enum Error: Swift.Error {
        case routineWithNameAlreadyExists
        case routineWithExercisesAlreadyExists
    }
    
    let routineStore: RoutineStore
    
    init(routineStore: RoutineStore) {
        self.routineStore = routineStore
    }
    
    func save(routine: Routine, completion: @escaping RoutineRepository.SaveRoutineCompletion) {
        
        let localRoutine = routine.toLocal()
        
        routineStore.readRoutines(with: routine.name, or: localRoutine.exercises) { [weak self] readRoutineResult in
            
            switch readRoutineResult {
            case let .success(routines):
                if routines.isEmpty {
                    self?.routineStore.create(localRoutine)
                    
                } else {
                    guard let firstRoutine = routines.first else { return }
                    
                    if localRoutine.name == firstRoutine.name {
                        completion(.failure(Error.routineWithNameAlreadyExists))
                        
                    } else {
                        // Only these two cases should exist, so if it isn't one it must be the other
                        completion(.failure(Error.routineWithExercisesAlreadyExists))
                    }
                }
            case .failure: break
            }
        }
    }
    
    func loadAllRoutines() -> [Routine] {
        return []
    }
}


class SaveRoutineUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let (_, routineStore) = makeSUT()
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineNameIsAlreadyCached_deliversRoutineWithNameAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let exp = expectation(description: "Wait for save routine completion")
        let routine = uniqueRoutine()
        
        sut.save(routine: routine) { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error as! LocalRoutineRepository.Error, .routineWithNameAlreadyExists)
            default:
                XCTFail("Expected result to be duplicate routine name, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        routineStore.completeReadRoutines(with: [routine.toLocal()])
        // Do not need to complete with save success since it should fail if there is no error
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let exp = expectation(description: "Wait for save routine completion")
        
        let routine = uniqueRoutine()
        
        sut.save(routine: routine) { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error as! LocalRoutineRepository.Error, .routineWithExercisesAlreadyExists)
            default:
                XCTFail("Expected result to be duplicate routine name, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        routineStore.completeReadRoutines(with: [routine.toLocal()])
        // Do not need to complete with save success since it should fail if there is no error
        
        wait(for: [exp], timeout: 1)
    }
    
    
    // MARK: - Helpers
    private func makeSUT() -> (sut: LocalRoutineRepository, routineStore: RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = LocalRoutineRepository(routineStore: routineStore)
        
        trackForMemoryLeaks(routineStore)
        trackForMemoryLeaks(sut)
        
        return (sut, routineStore)
    }
    
    
    private func uniqueExercise() -> Exercise {
        return Exercise(
            id: UUID(),
            name: UUID().uuidString,
            creationDate: Date(),
            exerciseRecords: [],
            tags: [])
    }
    
    
    private func uniqueRoutine() -> Routine {
        return Routine(
            id: UUID(),
            name: UUID().uuidString,
            creationDate: Date(),
            exercises: [uniqueExercise(), uniqueExercise()],
            routineRecords: [])
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

