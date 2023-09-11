//
//  ORMCalculationPolicyTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 9/1/23.
//

import XCTest
import RoutineRepository


class ORMCalculationPolicyTests: XCTestCase {
    
    
    func test_ORMCalculationPolicy_InvalidRepsWithValidWeight_deliversNil() {
        
        // given
        let reps = 0.0
        let weight = 225.0
        
        // when
        let orm = ORMCalculationPolicy.calculateORM(reps: reps, weight: weight)
        
        // then
        XCTAssertNil(orm)
    }
    
    
    func test_ORMCalculationPolicy_ValidRepsWithInvalidWeight_deliversNil() {
        
        // given
        let reps = 5.0
        let weight = 0.0
        
        // when
        let orm = ORMCalculationPolicy.calculateORM(reps: reps, weight: weight)
        
        // then
        XCTAssertNil(orm)
    }
    
    
    func test_ORMCalculationPolicy_validRepsAndWeightFollowingBrzyckiFormula_deliversExpectedORM() {
        
        // given
        let reps = 5.0
        let weight = 225.0
        
        // when
        let orm = ORMCalculationPolicy.calculateORM(reps: reps, weight: weight)
        
        // then
        XCTAssertEqual(orm, 253.125)
    }
}
