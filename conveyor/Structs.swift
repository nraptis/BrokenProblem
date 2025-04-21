//
//  Span.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

enum Direction: UInt8, CaseIterable {
    case left
    case right
}

struct DropSweepAction {
    enum ActionType {
        case add
        case remove
    }
    let x: Int
    let conveyor: Conveyor
    let type: ActionType
}

typealias CollideSweepAction = DropSweepAction

enum Drop: Equatable, CustomStringConvertible {
    case empty(Span)
    case conveyor(Span, Conveyor)
    static func == (lhs: Drop, rhs: Drop) -> Bool {
        switch (lhs, rhs) {
        case (.empty(let ls), .empty(let rs)):
            return ls == rs
        case (.conveyor(let ls, let lc), .conveyor(let rs, let rc)):
            if ls != rs { return false }
            if lc != rc { return false }
            return true
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .empty(let span):
            return "DropEmpty{ \(span) }"
        case .conveyor(let span, let conveyor):
            return "DropConveyor{ \(span) | \(conveyor.name) }"
        }
    }
}

enum Boundary: Equatable {
    case closed(Int)
    case open(Int)
    static func == (lhs: Boundary, rhs: Boundary) -> Bool {
        switch (lhs, rhs) {
        case (.closed(let l), .closed(let r)):
            return l == r
        case (.open(let l), .open(let r)):
            return l == r
        default:
            return false
        }
    }
}

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
