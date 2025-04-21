//
//  Span.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

enum Span: Equatable, CustomStringConvertible {
    case point(Int)
    case interval(Interval)
    static func == (lhs: Span, rhs: Span) -> Bool {
        switch (lhs, rhs) {
        case (.point(let lp), .point(let rp)):
            return lp == rp
        case (.interval(let li), .interval(let ri)):
            return li == ri
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .point(let p):
            return "[\(p)]"
        case .interval(let i):
            return "\(i)"
        }
    }
    
}
