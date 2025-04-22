//
//  IntConveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

struct CountConveyor: Hashable {
    let count: Int
    let conveyor: Conveyor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(conveyor.index)
    }
    
    static func == (lhs: CountConveyor, rhs: CountConveyor) -> Bool {
        lhs.count == rhs.count && lhs.conveyor.index == rhs.conveyor.index
    }
}

struct LengthConveyor: Hashable {
    let length: Int
    let conveyor: Conveyor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(length)
        hasher.combine(conveyor.index)
    }
    
    static func == (lhs: LengthConveyor, rhs: LengthConveyor) -> Bool {
        lhs.length == rhs.length && lhs.conveyor.index == rhs.conveyor.index
    }
}

struct CountLengthConveyor: Hashable {
    let count: Int
    let length: Int
    let conveyor: Conveyor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(length)
        hasher.combine(conveyor.index)
    }
    
    static func == (lhs: CountLengthConveyor, rhs: CountLengthConveyor) -> Bool {
        lhs.count == rhs.count && lhs.length == rhs.length && lhs.conveyor.index == rhs.conveyor.index
    }
}
