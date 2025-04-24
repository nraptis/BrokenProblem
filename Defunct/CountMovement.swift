//
//  CountMovement.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

struct CountMovementConveyor: Hashable {
    let count: Int
    let movement: Int
    let conveyor: Conveyor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(count)
        hasher.combine(movement)
        hasher.combine(conveyor.index)
    }
    
    static func == (lhs: CountMovementConveyor, rhs: CountMovementConveyor) -> Bool {
        lhs.count == rhs.count && lhs.movement == rhs.movement && lhs.conveyor.index == rhs.conveyor.index
    }
    
}
