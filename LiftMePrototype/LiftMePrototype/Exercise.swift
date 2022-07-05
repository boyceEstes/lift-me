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
    let lastDoneDate: Date?
    let personalRecord: Int
    
    init(name: String) {
        self.name = name
        self.lastDoneDate = Bool.random() == true ? Date() : nil
        self.personalRecord = Int.random(in: 100..<300)
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
