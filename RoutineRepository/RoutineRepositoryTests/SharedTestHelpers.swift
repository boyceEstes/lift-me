//
//  SharedTestHelpers.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 10/10/22.
//

import Foundation
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


func uniqueRoutine(name: String? = nil, exercises: [Exercise]? = nil) -> Routine {
    
    let routine = Routine(
        id: UUID(),
        name: name ?? UUID().uuidString,
        creationDate: Date(),
        exercises: exercises ?? [uniqueExercise(), uniqueExercise()],
        routineRecords: [])
    
    return routine
}
