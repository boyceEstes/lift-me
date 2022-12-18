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


func uniqueRoutine(id: UUID? = nil, name: String? = nil, exercises: [Exercise]? = nil) -> Routine {
    
    let routine = Routine(
        id: id ?? UUID(),
        name: name ?? UUID().uuidString,
        creationDate: Date(),
        exercises: exercises ?? [uniqueExercise(), uniqueExercise()],
        routineRecords: [])
    
    return routine
}
