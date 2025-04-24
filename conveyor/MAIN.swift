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

func geUniformTravelDistance(conveyors: [Conveyor],
                                            drops: [Drop]) -> Double {
    
    let MULTIPLIER_I: Int = 8_000_000
    let MULTIPLIER_D: Double = Double(MULTIPLIER_I)
    
    var result = Double(0.0)
    
    for drop in drops {
        switch drop {
            
        case .conveyor(let span, let conveyor):
            let percent_m = Conveyor.percent(span: span, multiplier: MULTIPLIER_D)

                let left_lhs = conveyor.average_left(span: span)
                let left_rhs = conveyor.cost_left_uniform
            
                let left_total = (left_lhs + left_rhs)
                
                let right_lhs = conveyor.average_right(span: span)
                let right_rhs = conveyor.cost_right_uniform
                
                let right_total = (right_lhs + right_rhs)
                
                let average = (left_total + right_total) / 2.0
                result += average * percent_m
            
        case .empty:
            break
        }
    }
    
    return (result / MULTIPLIER_D)
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
    findFallCostsUniform(conveyors: conveyors)

    let drops = getDrops(conveyors: conveyors)
    registerDrops(conveyors: conveyors, drops: drops)
    findRemainingMovement(conveyors: conveyors)
    
    findFallSums(conveyors: conveyors)
    findFalls(conveyors: conveyors)
    
    //findFalloffCosts(conveyors: conveyors)
    
    
    let uniform = geUniformTravelDistance(conveyors: conveyors, drops: drops)
    var result = uniform
    
    
    let mock = getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                      drops: drops,
                                                      locked_conveyor: Conveyor(name: "mock",
                                                                                index: -1,
                                                                                x1: -1000,
                                                                                x2: -1000,
                                                                                y: -1000),
                                                      locked_direction: .left)

    print("uniform = \(uniform)")
    print("mock = \(mock)")
    
    
    for conveyor in conveyors {
        print(conveyor)
        //print(conveyor.edge)
        
        for span in conveyor.dropSpans {
            print("Drop Span: \(span)")
            let average_left = conveyor.average_left(span: span)
            let average_right = conveyor.average_right(span: span)
            print("average_left = \(average_left)")
            print("average_right = \(average_right)")
        }
        
    }
    
    
    
    return Float(result)
    
}

func getMinExpectedHorizontalTravelDistance(_ testCase: TestCase) -> Float {
    getMinExpectedHorizontalTravelDistance(testCase.conveyors)
}

func getMinExpectedHorizontalTravelDistance(_ N: Int, _ H: [Int], _ A: [Int], _ B: [Int]) -> Float {
    var conveyors = [Conveyor]()
    for index in 0..<N {
        let y = H[index]; let x1 = A[index]; let x2 = B[index]
        let conveyor = Conveyor(name: "c\(index)", index: index, x1: x1, x2: x2, y: y)
        conveyors.append(conveyor)
    }
    return getMinExpectedHorizontalTravelDistance(conveyors)
}
