//
//  Span.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

let INVALID = Double(-100_000_000.0)

struct VeryBestOne {
    let conveyor: Conveyor
    let direction: Direction
}

class Fall {
    let x: Int
    let amount: Double
    
    init(x: Int, amount: Double) {
        self.x = x
        self.amount = amount
    }
}

enum Direction {
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

class Drop {
    let conveyor: Conveyor
    let span: Span
    init(conveyor: Conveyor, span: Span) {
        self.conveyor = conveyor
        self.span = span
    }
}

class Span {
    let x1: Int
    let x2: Int
    let is_range: Bool
    init(x1: Int, x2: Int, is_range: Bool) {
        self.x1 = x1
        self.x2 = x2
        self.is_range = is_range
    }
}


