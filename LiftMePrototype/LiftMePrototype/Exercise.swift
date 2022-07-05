//
//  Exercise.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 7/5/22.
//

import Foundation


struct Exercise: Identifiable {

    let id = UUID()
    let name: String
    let description: String
    let lastDoneDate: Date?
    let personalRecord: Int
    let records: [ExerciseRecord]
    
    init(name: String) {
        self.name = name
        self.description = "This is an exercise that requires dedication, pizzaz, and jazz to complete. Attempt at your own risk"
        self.lastDoneDate = Bool.random() == true ? Date() : nil
        self.personalRecord = Int.random(in: 100..<300)
        self.records = ExerciseRecord.mocks
    }
    
    var lastDoneDateString: String {
        if let lastDoneDate = lastDoneDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let stringDate = formatter.string(from: lastDoneDate)
            return "Last completed: \(stringDate)"
        } else {
            return "No records found"
        }
    }
    
    
    static var mock: Exercise {
        return mocks.first ?? Exercise(name: "Bicep Curl")
    }
    
    
    static var mocks: [Exercise] {
        return [Exercise(name: "Deadlift"), Exercise(name: "Bench Press"), Exercise(name: "Squat"), Exercise(name: "Tricep Extension")]
    }
}


struct ExerciseRecord: Identifiable {
    
    let id = UUID()
    let dateTime: Date
    let sets: [SetRecord]
    
    
    static var mock: ExerciseRecord {
        return ExerciseRecord(dateTime: Date(), sets: SetRecord.mocks)
    }
    
    
    static var mocks: [ExerciseRecord] {
        var exerciseRecords = [ExerciseRecord]()
        for _ in 0..<Int.random(in: 1...8) {
            exerciseRecords.append(ExerciseRecord.mock)
        }
        return exerciseRecords
    }
}


struct SetRecord: Identifiable {
    
    let id = UUID()
    let repCount: Int?
    let duration: Int?
    let weight: Int
    let difficulty: Int // 5 is max
    
    
    static var mock: SetRecord {
        
        let reps = Int.random(in: 6...20)
        let weight = Int.random(in: 40...200)
        let difficulty = Int.random(in: 1...5)
        return SetRecord(repCount: reps, duration: nil, weight: weight, difficulty: difficulty)
    }
    
    
    static var mocks: [SetRecord] {
        
        var sets = [SetRecord]()
        for _ in 0..<Int.random(in: 2...5) {
            sets.append(SetRecord.mock)
        }
        return sets
    }
}
