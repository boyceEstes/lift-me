//
//  Exercise.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 7/5/22.
//

import Foundation

extension DateFormatter {
    
    static var mediumDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


enum TagType: String, CaseIterable, Identifiable, Equatable {
    
    var id: Int { self.hashValue }
    
    case back
    case chest
    case tricep
    case bicep
    case hamstrings
    case quads
    case glutes
}


struct Tag: Identifiable {
    
    let name: String
    
    var id: Int { self.name.hashValue }
}


struct Exercise: Identifiable, Hashable, Equatable {

    let id = UUID()
    let name: String
    let description: String
    let lastDoneDate: Date?
    let personalRecord: Int
    let records: [ExerciseRecord]
    let tags: [TagType]
    
    init(name: String, tags: [TagType] = []) {
        self.name = name
        self.description = "This is an exercise that requires dedication, pizzaz, and jazz to complete. Attempt at your own risk"
        self.lastDoneDate = Bool.random() == true ? Date() : nil
        self.personalRecord = Int.random(in: 100..<300)
        self.records = ExerciseRecord.mocks
        self.tags = tags
    }
    
    var lastDoneDateString: String {
        if let lastDoneDate = lastDoneDate {
            let stringDate = DateFormatter.mediumDate.string(from: lastDoneDate)
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


struct ExerciseRecord: Identifiable, Equatable, Hashable {
    
    let id = UUID()
    let dateTime: Date
    let sets: [SetRecord]
    
    var numberOfSets: Int {
        sets.count
    }
    
    
    var dateCompletedString: String {
        return "\(DateFormatter.mediumDate.string(from: dateTime))"
    }
    
    
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


struct SetRecord: Identifiable, Equatable, Hashable {
    
    let id = UUID()
    let repCount: Int?
    let duration: Int?
    let weight: Int
    let difficulty: Int // 5 is max
    
    var setData: String {
        return "\(weight)lbs x \(repCount ?? 0)"
    }
    
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
