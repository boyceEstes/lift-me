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


protocol RoutineStore {
    
    func create(_ routine: LocalRoutine)
}


private extension Routine {
    
    func toLocal() -> LocalRoutine {
        return LocalRoutine(
            id: self.id,
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



class RoutineStoreSpy: RoutineStore {

    enum ReceivedMessage: Equatable {
        case create(LocalRoutine)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    init() {
    }
    
    // Conformance to RoutineStore
    func create(_ routine: LocalRoutine) {
        receivedMessages.append(.create(routine))
    }
    
    // Spy work 🕵🏼‍♂️
}


class LocalRoutineRepository: RoutineRepository {
    
    let routineStore: RoutineStore
    
    init(routineStore: RoutineStore) {
        self.routineStore = routineStore
    }
    
    func save(routine: Routine) {
        routineStore.create(routine.toLocal())
    }
    
    func loadAllRoutines() -> [Routine] {
        return []
    }
}


class SaveRoutineUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let routineStore = RoutineStoreSpy()
        let _ = LocalRoutineRepository(routineStore: routineStore)
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }
    
    
    func test_routineRepository_saveDuplicateRoutineName_deliversDuplicateRoutineNameError() {
        
        let routineStore = RoutineStoreSpy()
        let sut = LocalRoutineRepository(routineStore: routineStore)
        
        let routine = Routine(
            id: UUID(),
            creationDate: Date(),
            exercises: [],
            routineRecords: [])
        sut.save(routine: <#T##Routine#>)
    }
}
