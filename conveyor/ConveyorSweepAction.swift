//
//  ConveyorSweepAction.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

struct ConveyorSweepAction {
    enum ActionType {
        case add
        case remove
    }
    let x: Int
    let conveyor: Conveyor
    let type: ActionType
}
