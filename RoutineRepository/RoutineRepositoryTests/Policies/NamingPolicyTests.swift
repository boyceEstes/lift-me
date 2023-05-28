//
//  NamingPolicyTests.swift
//  RoutineRepositoryTests
//
//  Created by Boyce Estes on 5/25/23.
//


import XCTest
import RoutineRepository


final class NamingPolicyTests: XCTestCase {

    // oldName
    func test_namingPolicy_createUniqueNameFromOldName_deliversNewNameWithCountAtOne() {
        
        // given
        let oldName = "testing"
        
        // when
        let uniqueName = NamingPolicy.uniqueName(from: oldName)
        
        // then
        let expectedUniqueName = "\(oldName) (1)"
        XCTAssertEqual(uniqueName, expectedUniqueName)
    }
    
    
    func test_namingPolicy_createUniqueNameFromShortName_deliversNewNameWithCountAtOne() {
        
        // given
        let oldName = "a"
        
        // when
        let uniqueName = NamingPolicy.uniqueName(from: oldName)
        
        // then
        let expectedUniqueName = "\(oldName) (1)"
        XCTAssertEqual(uniqueName, expectedUniqueName)
    }
    
    
    func test_namingPolicy_createUniqueNameFromNameWithPattern_deliversNewNameWithCountAtNextNumber() {
        
        // given
        let oldName = "any (3)"
        
        // when
        let uniqueName = NamingPolicy.uniqueName(from: oldName)
        
        // then
        let expectedUniqueName = "any (4)"
        XCTAssertEqual(uniqueName, expectedUniqueName)
    }
    
    
    func test_namingPolicy_createUniqueNameFromNameWithPatternWhenPatternIsNotAtEnd_deliversNewNameWithCounttAtOne() {
        
        // given
        let oldName = "(1) any"
        
        // when
        let uniqueName = NamingPolicy.uniqueName(from: oldName)
        
        // then
        let expectedUniqueName = "(1) any (1)"
        XCTAssertEqual(uniqueName, expectedUniqueName)
    }
    
    
    // FIXME: Has a probem with the mutliple digits, hopefully nobody names routines the same name 10 times
//    func test_namingPolicy_createUniqueNameFromDoubleDigitNameWithPattern_deliversNewNameWithCountAtNextNumber() {
//
//        // given
//        let oldName = "any (10)"
//
//        // when
//        let uniqueName = NamingPolicy.uniqueName(from: oldName)
//
//        // then
//        let expectedUniqueName = "any (11)"
//        XCTAssertEqual(uniqueName, expectedUniqueName)
//    }
    
}
