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
    typealias CreateRoutineResult = Result<Void, Error>
    
    typealias ReadRoutineCompletion = (ReadRoutineResult) -> Void
    typealias CreateRoutineCompletion = (CreateRoutineResult) -> Void
    
    func create(_ routine: LocalRoutine, completion: @escaping CreateRoutineCompletion)
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
    private(set) var createRoutineCompletions = [RoutineStore.CreateRoutineCompletion]()
    
    init() {}
    
    // Conformance to RoutineStore
    func create(_ routine: LocalRoutine, completion: @escaping RoutineStore.CreateRoutineCompletion) {
        
        receivedMessages.append(.createRoutine(routine))
        createRoutineCompletions.append(completion)
    }
    
    
    func readRoutines(with name: String, or exercises: [LocalExercise], completion: @escaping RoutineStore.ReadRoutineCompletion) {
        
        receivedMessages.append(.readRoutines(name: name, exercises: exercises))
        readRoutineCompletions.append(completion)
    }
    
    // Spy work 🕵🏼‍♂️
    func completeReadRoutines(with routines: [LocalRoutine], at index: Int = 0) {
        readRoutineCompletions[index](.success(routines))
    }
    
    
    func completeReadRoutines(with error: NSError, at index: Int = 0) {
        readRoutineCompletions[index](.failure(error))
    }
    
    
    func completeCreateRoutine(with error: NSError, at index: Int = 0) {
        createRoutineCompletions[index](.failure(error))
    }
}


class LocalRoutineRepository: RoutineRepository {
    
    enum Error: Swift.Error {
        case routineWithNameAlreadyExists
        case routineWithExercisesAlreadyExists(cachedRoutineName: String)
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
                    self?.routineStore.create(localRoutine) { createRoutineResult in
                        switch createRoutineResult {
                        case let .failure(error):
                            completion(.failure(error))
                            
                        default: break
                        }
                    }
                    
                } else {
                    guard let firstRoutine = routines.first else { return }
                    
                    if localRoutine.name == firstRoutine.name {
                        completion(.failure(Error.routineWithNameAlreadyExists))
                        
                    } else {
                        // Only these two cases should exist, so if it isn't one it must be the other
                        completion(.failure(Error.routineWithExercisesAlreadyExists(cachedRoutineName: firstRoutine.name)))
                    }
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func loadAllRoutines() -> [Routine] {
        return []
    }
}


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}



class SaveRoutineUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let (_, routineStore) = makeSUT()
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineNameIsAlreadyCached_deliversRoutineWithNameAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
                
        let name = "Any"
        let routine = uniqueRoutine(name: name)
        let cachedRoutineWithSameName = uniqueRoutine(name: name)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithNameAlreadyExists)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameName.toLocal()])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(exercises: exercises)
        let cachedRoutineWithSameExercises = uniqueRoutine(exercises: exercises)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithExercisesAlreadyExists(cachedRoutineName: cachedRoutineWithSameExercises.name))) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.toLocal()])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithNameAndExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let name = "Any"
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(name: name, exercises: exercises)
        let cachedRoutineWithSameExercises = uniqueRoutine(name: name, exercises: exercises)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithNameAlreadyExists)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.toLocal()])
        }
    }
    
    
    func test_routineRepository_saveRoutineReadRoutinesWithNameAndExercisesFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine()
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: .failure(error)) {
            routineStore.completeReadRoutines(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineCreateRoutineFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine()
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: .failure(error)) {
            routineStore.completeReadRoutines(with: [])
            routineStore.completeCreateRoutine(with: error)
        }
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalRoutineRepository, routineStore: RoutineStoreSpy) {
        
        let routineStore = RoutineStoreSpy()
        let sut = LocalRoutineRepository(routineStore: routineStore)
        
        trackForMemoryLeaks(routineStore, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, routineStore)
    }
    
    
    private func save(routine: Routine, on sut: LocalRoutineRepository, completesWith expectedResult: RoutineRepository.SaveRoutineResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for save routine completion")
        
        sut.save(routine: routine) { result in
            
            switch (result, expectedResult) {
            case let (.failure(error), .failure(expectedError)):
                XCTAssertEqual(error as NSError, expectedError as NSError, "Got \(result) but expected \(expectedResult)", file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(result) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func uniqueExercise() -> Exercise {
        return Exercise(
            id: UUID(),
            name: UUID().uuidString,
            creationDate: Date(),
            exerciseRecords: [],
            tags: [])
    }
    
    
    private func uniqueRoutine(name: String? = nil, exercises: [Exercise]? = nil) -> Routine {
        
        return Routine(
            id: UUID(),
            name: name ?? UUID().uuidString,
            creationDate: Date(),
            exercises: exercises ?? [uniqueExercise(), uniqueExercise()],
            routineRecords: [])
    }
    
    
    private func anyNSError() -> NSError {
        return NSError(domain: "Any", code: 0)
    }
}
