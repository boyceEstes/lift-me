//
//  LiftMeExercisesTestHelpers.swift
//  
//
//  Created by Boyce Estes on 4/18/22.
//

import Foundation
import ExerciseRepository
import XCTest


func makeUniqueExercise() -> Exercise {
    return Exercise(id: UUID(), name: "any", dateCreated: Date(), desc: "any", exerciseRecords: [])
}


func makeUniqueExerciseTuple() -> (model: Exercise, local: LocalExercise) {
    
    let model = makeUniqueExercise()
    let local = LocalExercise(id: model.id, name: model.name, dateCreated: model.dateCreated, desc: model.desc, exerciseRecords: model.exerciseRecords.toLocal())
    return (model, local)
}


func makeUniqueExercisesTuple() -> (models: [Exercise], local: [LocalExercise]) {
    
    let models = [makeUniqueExercise(), makeUniqueExercise()]
    let local = models.toLocal()
    return (models, local)
}


func makeUniqueExerciseRecord() -> ExerciseRecord {
    
    let exercise = makeUniqueExercise()
    return ExerciseRecord(exerciseRecordID: UUID(), dateTime: Date(), exercise: exercise, sets: [])
}


func makeUniqueExerciseRecordTuple() -> (model: ExerciseRecord, local: LocalExerciseRecord) {
    
    let exerciseRecord = makeUniqueExerciseRecord()
    let exerciseRecordLocal = exerciseRecord.toLocal()
    return (exerciseRecord, exerciseRecordLocal)
}


func makeUniqueSetRecord() -> SetRecord {
    
    return SetRecord(
        exerciseRecord: makeUniqueExerciseRecord(),
        duration: nil,
        repCount: 5,
        weight: 100,
        difficulty: 4)
}


func makeUniqueSetRecordTuple() -> (model: SetRecord, local: LocalSetRecord){
    
    let exerciseRecord = makeUniqueExerciseRecord()
    
    let setRecord = SetRecord(
        exerciseRecord: exerciseRecord,
        duration: nil,
        repCount: 5,
        weight: 100,
        difficulty: 4)
    
    return (setRecord, setRecord.toLocal())
}


func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}


extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}

