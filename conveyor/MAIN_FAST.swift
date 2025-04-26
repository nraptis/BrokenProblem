//
//  M_E_T_D.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

func getMinExpectedHorizontalTravelDistance(conveyors: [Conveyor],
                                            drops: [Drop],
                                            locked_conveyor: Conveyor,
                                            locked_direction: Direction) -> Double {
    
    let MULTIPLIER_I: Int = 8_000_000
    let MULTIPLIER_D: Double = Double(MULTIPLIER_I)
    
    var result = Double(0.0)
    
    for drop in drops {
        let conveyor = drop.conveyor
        let span = drop.span
        let percent_m = Conveyor.percent(span: span, multiplier: MULTIPLIER_D)
        if conveyor.index == locked_conveyor.index {
            
            switch locked_direction {
            case .left:
                
                let left_lhs = conveyor.average_left(span: span)
                let left_rhs = getFallCostLeft(conveyor: conveyor,
                                               locked_conveyor: locked_conveyor,
                                               locked_direction: locked_direction)
                let left_total = (left_lhs + left_rhs)
                result += left_total * percent_m
                
            case .right:
                let right_lhs = conveyor.average_right(span: span)
                let right_rhs = getFallCostRight(conveyor: conveyor,
                                                 locked_conveyor: locked_conveyor,
                                                 locked_direction: locked_direction)
                let right_total = (right_lhs + right_rhs)
                result += right_total * percent_m
            }
        } else {
            let left_lhs = conveyor.average_left(span: span)
            let left_rhs = getFallCostLeft(conveyor: conveyor,
                                           locked_conveyor: locked_conveyor,
                                           locked_direction: locked_direction)
            
            let left_total = (left_lhs + left_rhs)
            
            let right_lhs = conveyor.average_right(span: span)
            let right_rhs = getFallCostRight(conveyor: conveyor,
                                             locked_conveyor: locked_conveyor,
                                             locked_direction: locked_direction)
            
            let right_total = (right_lhs + right_rhs)
            
            let average = (left_total + right_total) / 2.0
            result += average * percent_m
        }
    }
    
    return (result / MULTIPLIER_D)
}

func getMinExpectedHorizontalTravelDistance(conveyors: [Conveyor]) -> Double {
    findColliders(conveyors: conveyors)
    let drops = getDrops(conveyors: conveyors)
    registerDrops(conveyors: conveyors, drops: drops)
    findRemainingMovement(conveyors: conveyors)
    ingest_cozts(conveyors: conveyors)
    
    let veryBestOne = findTheVeryBestOne(conveyors: conveyors)
    let result = getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                        drops: drops,
                                                        locked_conveyor: veryBestOne.conveyor,
                                                        locked_direction: veryBestOne.direction)
    return result
}

func getMinExpectedHorizontalTravelDistance(_ N: Int, _ H: [Int], _ A: [Int], _ B: [Int]) -> Double {
    var conveyors = [Conveyor]()
    for index in 0..<N {
        let y = H[index]; let x1 = A[index]; let x2 = B[index]
        let conveyor = Conveyor(index: index, x1: x1, x2: x2, y: y)
        conveyors.append(conveyor)
    }
    return getMinExpectedHorizontalTravelDistance(conveyors: conveyors)
}

