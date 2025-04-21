//
//  M_E_T_D.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

// @Precondition: conveyor is the conveyor from which we fall
//                off of to-the-right, we do not include any
//                travel costs for the conveyor itself.

func getFallCostRight(x: Int,
                      conveyor: Conveyor,
                      collider: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    let cost_lhs = Double(abs(collider.x2 - x))
    let cost_rhs = getFallCostRight(conveyor: collider,
                                    locked_conveyor: locked_conveyor,
                                    locked_direction: locked_direction)
    return cost_lhs + cost_rhs
}

func getFallCostLeft(x: Int,
                     conveyor: Conveyor,
                     collider: Conveyor,
                     locked_conveyor: Conveyor,
                     locked_direction: Direction) -> Double {
    let cost_lhs = Double(abs(x - collider.x1))
    let cost_rhs = getFallCostLeft(conveyor: collider,
                                   locked_conveyor: locked_conveyor,
                                   locked_direction: locked_direction)
    return cost_lhs + cost_rhs
}

func getFallCostRight(conveyor: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    
    if let right_collider = conveyor.right_collider {
        if right_collider == locked_conveyor {
            switch locked_direction {
            case .left:
                return getFallCostLeft(x: conveyor.x2,
                                       conveyor: conveyor,
                                       collider: right_collider,
                                       locked_conveyor: locked_conveyor,
                                       locked_direction: locked_direction)
            case .right:
                return getFallCostRight(x: conveyor.x2,
                                        conveyor: conveyor,
                                        collider: right_collider,
                                        locked_conveyor: locked_conveyor,
                                        locked_direction: locked_direction)
            }
        } else {
            let left_cost = getFallCostLeft(x: conveyor.x2,
                                            conveyor: conveyor,
                                            collider: right_collider,
                                            locked_conveyor: locked_conveyor,
                                            locked_direction: locked_direction)
            let right_cost = getFallCostRight(x: conveyor.x2,
                                              conveyor: conveyor,
                                              collider: right_collider,
                                              locked_conveyor: locked_conveyor,
                                              locked_direction: locked_direction)
            return (left_cost + right_cost) / 2.0
        }
        
    } else {
        return 0.0
    }
}

func getFallCostLeft(conveyor: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    
    if let left_collider = conveyor.left_collider {
        if left_collider == locked_conveyor {
            switch locked_direction {
            case .left:
                return getFallCostLeft(x: conveyor.x1,
                                       conveyor: conveyor,
                                       collider: left_collider,
                                       locked_conveyor: locked_conveyor,
                                       locked_direction: locked_direction)
            case .right:
                return getFallCostRight(x: conveyor.x1,
                                        conveyor: conveyor,
                                        collider: left_collider,
                                        locked_conveyor: locked_conveyor,
                                        locked_direction: locked_direction)
            }
        } else {
            let left_cost = getFallCostLeft(x: conveyor.x1,
                                            conveyor: conveyor,
                                            collider: left_collider,
                                            locked_conveyor: locked_conveyor,
                                            locked_direction: locked_direction)
            let right_cost = getFallCostRight(x: conveyor.x1,
                                              conveyor: conveyor,
                                              collider: left_collider,
                                              locked_conveyor: locked_conveyor,
                                              locked_direction: locked_direction)
            return (left_cost + right_cost) / 2.0
        }
    } else {
        return 0.0
    }
}

func getMinExpectedHorizontalTravelDistance(conveyors: [Conveyor],
                                            drops: [Drop],
                                            locked_conveyor: Conveyor,
                                            locked_direction: Direction) -> Double {
    
    let MULTIPLIER_I: Int = 8_000_000
    let MULTIPLIER_D: Double = Double(MULTIPLIER_I)
    
    var result = Double(0.0)
    
    for drop in drops {
        switch drop {
            
        case .conveyor(let span, let conveyor):
            let percent_m = Conveyor.percent(span: span, multiplier: MULTIPLIER_D)
            if conveyor == locked_conveyor {
                
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
        case .empty:
            break
        }
    }
    
    return (result / MULTIPLIER_D)
}



func getMinExpectedHorizontalTravelDistance(_ conveyors: [Conveyor]) -> Float {
    
    for conveyor in conveyors {
        print(conveyor)
    }
    
    findColliders(conveyors: conveyors)
    
    let drops = getDrops(conveyors: conveyors)
    
    var result = Double(100_000_000_000_000_000_000_000_000.0)
    
    for conveyor in conveyors {
        for direction in Direction.allCases {
            let result_for_locked_and_dir = getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                                                   drops: drops,
                                                                                   locked_conveyor: conveyor,
                                                                                   locked_direction: direction)
            print("for locked: \(conveyor) and dir: \(direction), result = \(result_for_locked_and_dir)")
            result = min(result, result_for_locked_and_dir)
        }
    }
    
    return Float(result)
    
}

func getMinExpectedHorizontalTravelDistance(_ testCase: TestCase) -> Float {
    getMinExpectedHorizontalTravelDistance(testCase.conveyors)
}

func getMinExpectedHorizontalTravelDistance(_ N: Int, _ H: [Int], _ A: [Int], _ B: [Int]) -> Float {
    // Write your code here
    
    var conveyors = [Conveyor]()
    for index in 0..<N {
        let y = H[index]
        let x1 = A[index]
        let x2 = B[index]
        let conveyor = Conveyor(name: "c\(index)", index: index, x1: x1, x2: x2, y: y)
        conveyors.append(conveyor)
    }
    
    return getMinExpectedHorizontalTravelDistance(conveyors)
    
}
