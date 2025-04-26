//
//  ALGORITHMS.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

func getFallCostRight(x: Int,
                      conveyor: Conveyor,
                      collider: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    let cost_lhs = Double(collider.x2 - x)
    let cost_rhs = getFallCostRight(conveyor: collider,
                                    locked_conveyor: locked_conveyor,
                                    locked_direction: locked_direction)
    let result = cost_lhs + cost_rhs
    return result
}

func getFallCostLeft(x: Int,
                     conveyor: Conveyor,
                     collider: Conveyor,
                     locked_conveyor: Conveyor,
                     locked_direction: Direction) -> Double {
    let cost_lhs = Double(x - collider.x1)
    let cost_rhs = getFallCostLeft(conveyor: collider,
                                   locked_conveyor: locked_conveyor,
                                   locked_direction: locked_direction)
    let result = cost_lhs + cost_rhs
    return result
}

func getFallCostRight(conveyor: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    
    if conveyor.cost_right_memo != INVALID {
        return conveyor.cost_right_memo
    }
    
    if let right_collider = conveyor.right_collider {
        if right_collider.index == locked_conveyor.index {
            switch locked_direction {
            case .left:
                let result = getFallCostLeft(x: conveyor.x2,
                                       conveyor: conveyor,
                                       collider: right_collider,
                                       locked_conveyor: locked_conveyor,
                                       locked_direction: locked_direction)
                conveyor.cost_right_memo = result
                return result
            case .right:
                let result = getFallCostRight(x: conveyor.x2,
                                        conveyor: conveyor,
                                        collider: right_collider,
                                        locked_conveyor: locked_conveyor,
                                        locked_direction: locked_direction)
                conveyor.cost_right_memo = result
                return result
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
            let result = (left_cost + right_cost) / 2.0
            conveyor.cost_right_memo = result
            return result
        }
        
    } else {
        let result = Double(0.0)
        conveyor.cost_right_memo = result
        return result
    }
}

func getFallCostLeft(conveyor: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    
    if conveyor.cost_left_memo != INVALID {
        return conveyor.cost_left_memo
    }
    
    if let left_collider = conveyor.left_collider {
        if left_collider.index == locked_conveyor.index {
            switch locked_direction {
            case .left:
                let result = getFallCostLeft(x: conveyor.x1,
                                             conveyor: conveyor,
                                             collider: left_collider,
                                             locked_conveyor: locked_conveyor,
                                             locked_direction: locked_direction)
                conveyor.cost_left_memo = result
                return result
            case .right:
                let result = getFallCostRight(x: conveyor.x1,
                                        conveyor: conveyor,
                                        collider: left_collider,
                                        locked_conveyor: locked_conveyor,
                                        locked_direction: locked_direction)
                conveyor.cost_left_memo = result
                return result
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
            let result = (left_cost + right_cost) / 2.0
            conveyor.cost_left_memo = result
            return result
        }
    } else {
        let result = Double(0.0)
        conveyor.cost_left_memo = result
        return result
    }
}

func findRemainingMovement(conveyors: [Conveyor]) {
    
    let conveyors = conveyors.sorted { $0.y < $1.y }
    
    for conveyor in conveyors {
        let movement_left_piece_1: Double
        let movement_left_piece_2: Double
        let movement_left_piece_3: Double
        let movement_left_piece_4: Double
        if let left_collider = conveyor.left_collider {
            movement_left_piece_1 = Double(conveyor.x1 - left_collider.x1)
            movement_left_piece_2 = Double(left_collider.x2 - conveyor.x1)
            movement_left_piece_3 = left_collider.remaining_movement_left
            movement_left_piece_4 = left_collider.remaining_movement_right
        } else {
            movement_left_piece_1 = 0.0
            movement_left_piece_2 = 0.0
            movement_left_piece_3 = 0.0
            movement_left_piece_4 = 0.0
        }
        
        conveyor.remaining_movement_left = 0.0
        conveyor.remaining_movement_left += movement_left_piece_1
        conveyor.remaining_movement_left += movement_left_piece_2
        conveyor.remaining_movement_left += movement_left_piece_3
        conveyor.remaining_movement_left += movement_left_piece_4
        conveyor.remaining_movement_left /= 2.0
        
        let movement_right_piece_1: Double
        let movement_right_piece_2: Double
        let movement_right_piece_3: Double
        let movement_right_piece_4: Double
        if let right_collider = conveyor.right_collider {
            movement_right_piece_1 = Double(right_collider.x2 - conveyor.x2)
            movement_right_piece_2 = Double(conveyor.x2 - right_collider.x1)
            movement_right_piece_3 = right_collider.remaining_movement_left
            movement_right_piece_4 = right_collider.remaining_movement_right
        } else {
            movement_right_piece_1 = 0.0
            movement_right_piece_2 = 0.0
            movement_right_piece_3 = 0.0
            movement_right_piece_4 = 0.0
        }
        
        conveyor.remaining_movement_right = 0.0
        conveyor.remaining_movement_right += movement_right_piece_1
        conveyor.remaining_movement_right += movement_right_piece_2
        conveyor.remaining_movement_right += movement_right_piece_3
        conveyor.remaining_movement_right += movement_right_piece_4
        conveyor.remaining_movement_right /= 2.0
    }
}

func findTheVeryBestOne(conveyors: [Conveyor]) -> VeryBestOne {
    
    var result_conveyor = conveyors[0]
    var result_direction = Direction.left
    var result_score = Double(-1.0)
    
    for conveyor in conveyors {
        
        let score_left = conveyor.cozt_left
        let score_right = conveyor.cozt_right
        let score_average = conveyor.cozt_random
        
        let improvement_left = score_average - score_left
        let improvement_right = score_average - score_right
        
        if improvement_right > result_score {
            result_score = improvement_right
            result_conveyor = conveyor
            result_direction = .right
        }
        
        if improvement_left > result_score {
            result_score = improvement_left
            result_conveyor = conveyor
            result_direction = .left
        }
    }

    let result = VeryBestOne(conveyor: result_conveyor, direction: result_direction)
    return result
}

