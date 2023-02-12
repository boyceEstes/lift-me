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


func uniqueRoutineRecord(id: UUID? = nil, creationDate: Date? = nil, completionDate: Date? = nil, exerciseRecords: [ExerciseRecord]? = nil, exercise: Exercise? = nil) -> RoutineRecord {
    
    let exerciseRecord = uniqueExerciseRecord(exercise: exercise ?? uniqueExercise())
    
    let routineRecord = RoutineRecord(
        id: id ?? UUID(),
        creationDate: creationDate ?? Date(),
        completionDate: completionDate ?? nil,
        exerciseRecords: exerciseRecords ?? [exerciseRecord])
    
    return routineRecord
}


func uniqueExerciseRecord(id: UUID? = nil, setRecords: [SetRecord]? = nil, exercise: Exercise? = nil) -> ExerciseRecord {
    
    let exerciseRecord = ExerciseRecord(
        id: id ?? UUID(),
        setRecords: setRecords ?? [uniqueSetRecord()],
        exercise: exercise ?? uniqueExercise())
    
    return exerciseRecord
}


func uniqueSetRecord() -> SetRecord {
    
    return SetRecord(
        id: UUID(),
        duration: nil,
        repCount: 0,
        weight: 0,
        difficulty: nil
    )
}


extension Date {
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
