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


func uniqueRoutineRecord(id: UUID? = nil, creationDate: Date? = nil, completionDate: Date? = nil) -> RoutineRecord {
    
    let routineRecord = RoutineRecord(
        id: id ?? UUID(),
        creationDate: creationDate ?? Date(),
        completionDate: completionDate ?? nil,
        exerciseRecords: [])
    
    return routineRecord
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
