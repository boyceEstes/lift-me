//
//  Inspection.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 10/23/22.
//

import Combine

public final class Inspection<V> {
    
    public let notice = PassthroughSubject<UInt, Never>()
    public var callbacks: [UInt: (V) -> Void] = [:]
    
    public init() {}
    
    public func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
