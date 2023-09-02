//
//  ORMCalculationPolicy.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 9/1/23.
//

import Foundation


public enum ORMFormula {
    case brzychki
}


public enum ORMCalculationPolicy {
    
    public static func calculateORM(reps: Double, weight: Double, formula: ORMFormula = .brzychki) -> Double? {
        
        switch formula {
        case .brzychki:
            return calculateORMWithBryzchkiFormula(reps: reps, weight: weight)
        }
    }
    
    
    private static func calculateORMWithBryzchkiFormula(reps: Double, weight: Double) -> Double? {
        
        guard reps != 0,
              weight != 0
        else {
            return nil
        }
        
        return weight * (36 / (37 - reps))
    }
}
