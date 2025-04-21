//
//  Interval.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/18/25.
//

import Foundation

struct Interval: Equatable, CustomStringConvertible {
    
    let start: Boundary
    let end: Boundary
    
    static func == (lhs: Interval, rhs: Interval) -> Bool {
        if lhs.start != rhs.start { return false }
        if lhs.end != rhs.end { return false }
        return true
    }
    
    var description: String {
        switch start {
        case .closed(let start_val):
            switch end {
            case .closed(let end_val):
                return "[\(start_val), \(end_val)]"
            case .open(let end_val):
                return "[\(start_val), \(end_val))"
            }
        case .open(let start_val):
            switch end {
            case .closed(let end_val):
                return "(\(start_val), \(end_val)]"
            case .open(let end_val):
                return "(\(start_val), \(end_val))"
            }
        }
    }
}
