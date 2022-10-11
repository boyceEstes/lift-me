//
//  SaveRoutineUseCaseTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/8/22.
//

import XCTest
import RoutineRepository


class SaveRoutineUseCaseTests: XCTestCase {
    
    func test_routineRepository_init_doesNotMessageStore() {
        
        let (_, routineStore) = makeSUT()
        
        XCTAssertEqual(routineStore.receivedMessages, [])
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineNameIsAlreadyCached_deliversRoutineWithNameAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
                
        let name = "Any"
        let routine = uniqueRoutine(name: name).model
        let cachedRoutineWithSameName = uniqueRoutine(name: name).local

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithNameAlreadyExists)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameName])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(exercises: exercises).model
        let cachedRoutineWithSameExercises = uniqueRoutine(exercises: exercises)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithExercisesAlreadyExists(cachedRoutineName: cachedRoutineWithSameExercises.model.name))) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.local])
        }
    }
    
    
    func test_routineRepository_saveRoutineWhenRoutineWithNameAndExercisesIsAlreadyCached_deliversRoutineWithExercisesAlreadyExistsError() {
        
        let (sut, routineStore) = makeSUT()
        
        let name = "Any"
        let exercises = [uniqueExercise(), uniqueExercise()]
        let routine = uniqueRoutine(name: name, exercises: exercises).model
        let cachedRoutineWithSameExercises = uniqueRoutine(name: name, exercises: exercises)

        save(routine: routine, on: sut, completesWith: .failure(LocalRoutineRepository.Error.routineWithNameAlreadyExists)) {
            routineStore.completeReadRoutines(with: [cachedRoutineWithSameExercises.local])
        }
    }
    
    
    func test_routineRepository_saveRoutineReadRoutinesWithNameAndExercisesFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: .failure(error)) {
            routineStore.completeReadRoutines(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineCreateRoutineFails_deliversError() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        let error = anyNSError()
        
        save(routine: routine, on: sut, completesWith: .failure(error)) {
            routineStore.completeReadRoutinesSuccessfully()
            routineStore.completeCreateRoutine(with: error)
        }
    }
    
    
    func test_routineRepository_saveRoutineSucceeds_deliversSuccess() {
        
        let (sut, routineStore) = makeSUT()
        
        let routine = uniqueRoutine().model
        
        save(routine: routine, on: sut, completesWith: .success(())) {
            routineStore.completeReadRoutinesSuccessfully()
            routineStore.completeCreateRoutineSuccessfully()
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
            case (.success, .success): break
               
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
    
    
    private func uniqueRoutine(name: String? = nil, exercises: [Exercise]? = nil) -> (model: Routine, local: LocalRoutine) {
        
        let routine = Routine(
            id: UUID(),
            name: name ?? UUID().uuidString,
            creationDate: Date(),
            exercises: exercises ?? [uniqueExercise(), uniqueExercise()],
            routineRecords: [])
        
        // map model to local model without using production toLocals
        // as they should be kept private from external modules
        let localRoutine = LocalRoutine(
            id: routine.id,
            name: routine.name,
            creationDate: routine.creationDate,
            exercises: routine.exercises.map {
                LocalExercise(
                    id: $0.id,
                    name: $0.name,
                    creationDate: $0.creationDate,
                    exerciseRecords: $0.exerciseRecords.map {
                        LocalExerciseRecord(
                            id: $0.id,
                            setRecords: $0.setRecords.map {
                                LocalSetRecord(
                                    id: $0.id,
                                    duration: $0.duration,
                                    repCount: $0.repCount,
                                    weight: $0.weight,
                                    difficulty: $0.difficulty)
                            })
                    },
                    tags: $0.tags.map {
                        LocalTag(id: $0.id, name: $0.name)
                    })
            },
            routineRecords: routine.routineRecords.map {
                LocalRoutineRecord(
                    id: $0.id,
                    creationDate: $0.creationDate,
                    completionDate: $0.completionDate,
                    exerciseRecords: $0.exerciseRecords.map {
                        LocalExerciseRecord(
                            id: $0.id,
                            setRecords: $0.setRecords.map {
                                LocalSetRecord(
                                    id: $0.id,
                                    duration: $0.duration,
                                    repCount: $0.repCount,
                                    weight: $0.weight,
                                    difficulty: $0.difficulty)
                            })
                    })
            })
        
        return (routine, localRoutine)
    }
}
