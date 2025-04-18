//
//  DropInfo.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

enum DropInfo: CustomStringConvertible {
    
    struct DropInfoData_Empty {
        let x1: Int
        let x2: Int
    }

    struct DropInfoData_Conveyor {
        let x1: Int
        let x2: Int
        let conveyor: Conveyor
    }
    
    case empty(DropInfoData_Empty)
    case conveyor(DropInfoData_Conveyor)
    
    var description: String {
        switch self {
        case .empty(let data):
            return "DropInfo => Empty [\(data.x1), \(data.x2)]"
        case .conveyor(let data):
            return "DropInfo => Conveyor [\(data.x1), \(data.x2)] @ \(data.conveyor.index) C[\(data.conveyor.x1), \(data.conveyor.x2)]"
        }
    }
    
}
