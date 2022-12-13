//
//  SharedTestHelpers.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 11/3/22.
//

import RoutineRepository

func anyNSError() -> NSError {
    return NSError(domain: "Any", code: 0)
}


func uniqueExercise() -> Exercise {
    return Exercise(
        id: UUID(),
        name: UUID().uuidString,
        creationDate: Date(),
        exerciseRecords: [],
        tags: [])
}


func uniqueRoutine(id: UUID? = nil, name: String? = nil, exercises: [Exercise]? = nil) -> (model: Routine, local: LocalRoutine) {
    
    let routine = Routine(
        id: id ?? UUID(),
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
