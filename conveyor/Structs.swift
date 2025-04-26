//
//  Span.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

let INVALID = Double(-1.0)

struct VeryBestOne {
    let conveyor: Conveyor
    let direction: Direction
}

enum Direction {
    case left
    case right
}

enum ActionType {
    case add
    case remove
}

struct DropSweepAction {
    let x: Int
    let conveyor: Conveyor
    let type: ActionType
}

struct Drop {
    let conveyor: Conveyor
    let span: Span
    init(conveyor: Conveyor, span: Span) {
        self.conveyor = conveyor
        self.span = span
    }
}

struct Span {
    let x1: Int
    let x2: Int
    init(x1: Int, x2: Int) {
        self.x1 = x1
        self.x2 = x2
    }
}

struct DropBlackHole {
    let x: Double
    var distance: Double
    var mass: Double

    init(x: Double, distance: Double, mass: Double) {
        self.x = x
        self.distance = distance
        self.mass = mass
    }
}
