//
//  NSManagedObjectContext+FailingStub.swift
//  ExerciseRepositoryTests
//
//  Created by Boyce Estes on 6/22/22.
//

import Foundation
import CoreData


extension NSManagedObjectContext {
    
    static func alwaysFailingFetchStub() -> Stub {
        Stub(source: #selector(NSManagedObjectContext.execute(_:)),
             destination: #selector(Stub.execute(_:)))
    }
    
    static func alwaysFailingSaveStub() -> Stub {
        Stub(source: #selector(NSManagedObjectContext.save),
             destination: #selector(Stub.save))
    }
    
    
    class Stub: NSObject {
        
        private let source: Selector
        private let destination: Selector
        
        init(source: Selector, destination: Selector) {
            self.source = source
            self.destination = destination
        }
        
        
        @objc
        func execute(_: Any) throws -> Any {
            throw anyNSError()
        }
        
        
        @objc
        func save() throws -> Any {
            throw anyNSError()
        }
        
        
        func startIntercepting() {
            method_exchangeImplementations(
                class_getInstanceMethod(NSManagedObjectContext.self, source)!,
                class_getInstanceMethod(Stub.self, destination)!
            )
        }
        
        
        deinit {
            method_exchangeImplementations(
                class_getInstanceMethod(Stub.self, destination)!,
                class_getInstanceMethod(NSManagedObjectContext.self, source)!
            )
        }
    }
}
