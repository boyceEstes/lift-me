//
//  DispatchQueueMainDecorator.swift
//  RoutineRepository
//
//  Created by Boyce Estes on 11/3/22.
//

import Foundation


class DispatchQueueMainDecorator<T> {
    
    let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(_ work: @escaping () -> Void) {
        guaranteeMainThread {
            work()
        }
    }
    
    // TODO: Make this check for main queue instead of main thread
    private func guaranteeMainThread(_ work: @escaping () -> Void) {
        
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
