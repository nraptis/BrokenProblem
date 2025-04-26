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

enum Direction {
    case left
    case right
}

enum Which {
    case fixed_left
    case fixed_right
    case random
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

class Span: CustomStringConvertible {
    let x1: Int
    let x2: Int
    init(x1: Int, x2: Int) {
        
        if (x1 == x2) {
            fatalError("span should not have 0 length, this is a misunderstanding!")
        }
        
        self.x1 = x1
        self.x2 = x2
    }
    
    var description: String {
        return "[\(x1)...\(x2)]"
    }
}
