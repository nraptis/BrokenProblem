//
//  DropInfo.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

enum DropInfo {
    
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
}
