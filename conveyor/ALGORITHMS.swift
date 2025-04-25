//
//  ALGORITHMS.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

func findFallSums(conveyors: [Conveyor]) {
    
    
    // Should set C1 right
    //            [           C1         ]
    //          3000
    //        [       C0     ]
    //   00  01  02  03  04  05  06  07  08  09  10
    
    let conveyors = conveyors.sorted { $0.y > $1.y }
    for conveyor in conveyors {

        var drop_sum_left = Double(0.0)
        var drop_sum_right = Double(0.0)
        
        for span in conveyor.dropSpans {
            let cost_left = conveyor.average_left(span: span)
            let cost_right = conveyor.average_right(span: span)
            
            //print("on \(conveyor.name), cost_left = \(cost_left), cost_right = \(cost_right)")
            
            drop_sum_left += Double(cost_left)
            drop_sum_right += Double(cost_right)
            
        }
        
        var fall_sum_left = Double(0.0)
        var fall_sum_right = Double(0.0)
        for fall in conveyor.falls {
            let distance_left = (fall.x - conveyor.x1)
            let distance_right = (conveyor.x2 - fall.x)
            fall_sum_left += fall.amount
            fall_sum_left += Double(distance_left)
            
            fall_sum_right += fall.amount
            fall_sum_right += Double(distance_right)
            //fall_sum_left += fall.amount + Double(distance_left)
            //fall_sum_right += fall.amount + Double(distance_right)
        }
        
        conveyor.fall_sum_left = (drop_sum_left + fall_sum_left) / 2.0
        conveyor.fall_sum_right = (drop_sum_right + fall_sum_right) / 2.0
        
        if let left_collider = conveyor.left_collider {
            let fall = Fall(x: conveyor.x1, amount: conveyor.fall_sum_left)
            left_collider.falls.append(fall)
        }
        
        if let right_collider = conveyor.right_collider {
            let fall = Fall(x: conveyor.x2, amount: conveyor.fall_sum_right)
            right_collider.falls.append(fall)
        }
    }
}

func findFalls(conveyors: [Conveyor]) {
    
    let conveyors = conveyors.sorted { $0.y > $1.y }
    for conveyor in conveyors {
        var fall_cost_random_left = Double(0.0)
        var fall_cost_random_right = Double(0.0)
        var fall_cost_fixed_left = Double(0.0)
        var fall_cost_fixed_right = Double(0.0)
        let remaining_movement_left = conveyor.remaining_movement_left
        let remaining_movement_right = conveyor.remaining_movement_right
        for span in conveyor.dropSpans {
            let cost_left = conveyor.average_left(span: span)
            let cost_right = conveyor.average_right(span: span)
            let add_left = cost_left + remaining_movement_left
            let add_right = cost_right + remaining_movement_right
            fall_cost_fixed_left += add_left
            fall_cost_fixed_right += add_right
            fall_cost_random_left += add_left
            fall_cost_random_right += add_right
        }
        
        for fall in conveyor.falls {
            let travel_left = Double(fall.x - conveyor.x1)
            let travel_right = Double(conveyor.x2 - fall.x)
            let add_left = (fall.amount + travel_left)
            let add_right = (fall.amount + travel_right)
            fall_cost_fixed_left += add_left
            fall_cost_fixed_right += add_right
            fall_cost_random_left += add_left
            fall_cost_random_right += add_right
        }
        
        let fall_cost_random = (fall_cost_fixed_left + fall_cost_fixed_right) / 2.0
        
        conveyor.fall_cost_fixed_left = fall_cost_fixed_left
        conveyor.fall_cost_fixed_right = fall_cost_fixed_right
        conveyor.fall_cost_random = fall_cost_random
    }
}

func getFallCostRight(x: Int,
                      conveyor: Conveyor,
                      collider: Conveyor,
                      locked_conveyor: Conveyor,
                      locked_direction: Direction) -> Double {
    let cost_lhs = Double(abs(collider.x2 - x))
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
    let cost_lhs = Double(abs(x - collider.x1))
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

func playMagicTheGathering(conveyors: [Conveyor]) -> VeryBestOne {
    
    var result_conveyor = conveyors[0]
    var result_direction = Direction.left
    var result_score = Double(-1.0)
    
    for conveyor in conveyors {

        
        print("This Conveyor: \(conveyor.name)")
        
        for drop in conveyor.dropSpans {
            print("$$$ \(conveyor.name) drop at [\(drop.x1) to \(drop.x2)], left cost = \(conveyor.average_left(span: drop)), right cost = \(conveyor.average_right(span: drop))")
        }
        for fall in conveyor.falls {
            let left_travel = fall.x - conveyor.x1
            let right_travel = conveyor.x2 - fall.x
            print("$$$ \(conveyor.name) fall at \(fall.x), amt \(fall.amount), left_d = \(left_travel), right_d = \(right_travel)")
        }
        
        
        
        
        var blackHoles = [BlackHole]()
        for span in conveyor.dropSpans {
            let mass = Double(span.x2 - span.x1)
            if mass > 0.0 {
                let center = Double(span.x1 + span.x2) / 2.0
                let blackHole = BlackHole(center: center, mass: mass)
                blackHoles.append(blackHole)
                print("BlackHole From Drop => \(blackHole.mass), \(blackHole.center)")
            }
        }
        
        for fall in conveyor.falls {
            let mass = Double(fall.amount)
            let center = Double(fall.x)
            if mass > 0.0 {
                let blackHole = BlackHole(center: center, mass: mass)
                blackHoles.append(blackHole)
                print("BlackHole From Fall => \(blackHole.mass), \(blackHole.center)")
            }
        }
        
        
        var sum_of_costs_left = Double(0.0)
        var sum_of_costs_right = Double(0.0)
        for blackHole in blackHoles {
            
            let distance_left = blackHole.center - Double(conveyor.x1) + conveyor.remaining_movement_left
            let distance_right = Double(conveyor.x2) - blackHole.center + conveyor.remaining_movement_right
            
            sum_of_costs_left += (distance_left * blackHole.mass) / 1_000_000.0
            sum_of_costs_right += (distance_right * blackHole.mass) / 1_000_000.0
        }
        
        let sum_of_costs_average = (sum_of_costs_left + sum_of_costs_right) / 2.0
        
        print("sum_of_costs_left = \(sum_of_costs_left)")
        print("sum_of_costs_right = \(sum_of_costs_right)")
        print("sum_of_costs_average = \(sum_of_costs_average)")
        
        let improvements_if_we_fix_left = sum_of_costs_average - sum_of_costs_left
        let improvements_if_we_fix_right = sum_of_costs_average - sum_of_costs_right
        
        if improvements_if_we_fix_left > result_score {
            result_conveyor = conveyor
            result_direction = .left
            result_score = improvements_if_we_fix_left
        }
        
        if improvements_if_we_fix_right > result_score {
            result_conveyor = conveyor
            result_direction = .right
            result_score = improvements_if_we_fix_right
        }
        
        
        
        
    }
    
    let result = VeryBestOne(conveyor: result_conveyor, direction: result_direction)
    return result
}

func findTheVeryBestOne(conveyors: [Conveyor]) -> VeryBestOne {
    
    var result_conveyor = conveyors[0]
    var result_direction = Direction.left
    var result_score = Double(-1.0)
    
    for conveyor in conveyors {

        
        print("This Conveyor: \(conveyor.name)")
        
        for drop in conveyor.dropSpans {
            print("@@ drop at [\(drop.x1) to \(drop.x2)], left cost = \(conveyor.average_left(span: drop)), right cost = \(conveyor.average_right(span: drop))")
        }
        for fall in conveyor.falls {
            let left_travel = fall.x - conveyor.x1
            let right_travel = conveyor.x2 - fall.x
            print("@@ fall at \(fall.x), amt \(fall.amount), left_d = \(left_travel), right_d = \(right_travel)")
        }
        
        //          [        c0        ]     ( ==> )
        //          @@ drop at [200000 to 700000], left cost = 250000.0, right cost = 250000.0
        //
        //      [      c1      ]
        //      @@ drop at [100000 to 200000], left cost = 50_000.0, right cost = 350_000.0
        //      @@ fall at 200000, amt 125000.0, left_d = 100000, right_d = 300000
        
        // If we set c0 to the right, these are the improvements:
        
        // We subtract out (125_000 + (200_000 / 2)) going left
        // We add 125_000 going right
        
        var improvements_if_we_fix_right = Double(0.0)
        var improvements_if_we_fix_left = Double(0.0)
        
        for span in conveyor.dropSpans {
            
            let left = conveyor.average_left(span: span)
            let right = conveyor.average_right(span: span)
            let average = (left + right) * 0.5
            
            improvements_if_we_fix_right += (average - right)
            improvements_if_we_fix_left += (average - left)
            
            if let left_collider = conveyor.left_collider {
                let previous_flow_left = (average / 2.0)
                let fixed_left_flow_left = left
                
                let previous_fall_left = Fall(x: conveyor.x1, amount: previous_flow_left)
                let fixed_left_fall_left = Fall(x: conveyor.x1, amount: fixed_left_flow_left)
                
                let adjustment_right = left_collider.full_cost(fall: previous_fall_left)
                let adjustment_left = -(left_collider.full_cost(fall: fixed_left_fall_left))

                improvements_if_we_fix_right += adjustment_right
                improvements_if_we_fix_left += adjustment_left
            }
            
            if let right_collider = conveyor.right_collider {
                let previous_flow_right = (average / 2.0)
                let fixed_right_flow_right = right
                
                let previous_fall_right = Fall(x: conveyor.x2, amount: previous_flow_right)
                let fixed_right_fall_right = Fall(x: conveyor.x2, amount: fixed_right_flow_right)
                
                let adjustment_right = -(right_collider.full_cost(fall: previous_fall_right))
                let adjustment_left = right_collider.full_cost(fall: fixed_right_fall_right)
                
                improvements_if_we_fix_right += adjustment_right
                improvements_if_we_fix_left += adjustment_left
            }
            
            print("\(conveyor.name) span \(span) improvements_if_we_fix_right = \(improvements_if_we_fix_right)")
            print("\(conveyor.name) span \(span) improvements_if_we_fix_left = \(improvements_if_we_fix_left)")
            
        }
        
        
        for fall in conveyor.falls {
            
            let left = conveyor.fall_value_left(fall: fall)
            let right = conveyor.fall_value_right(fall: fall)
            let average = (left + right) * 0.5
            
            improvements_if_we_fix_right += (average - right)
            improvements_if_we_fix_left += (average - left)
            
            if let left_collider = conveyor.left_collider {
                let previous_flow_left = (average / 2.0)
                let fixed_left_flow_left = left
                
                let previous_fall_left = Fall(x: conveyor.x1, amount: previous_flow_left)
                let fixed_left_fall_left = Fall(x: conveyor.x1, amount: fixed_left_flow_left)
                
                let adjustment_right = left_collider.full_cost(fall: previous_fall_left)
                let adjustment_left = -(left_collider.full_cost(fall: fixed_left_fall_left))

                improvements_if_we_fix_right += adjustment_right
                improvements_if_we_fix_left += adjustment_left
            }
            
            if let right_collider = conveyor.right_collider {
                let previous_flow_right = (average / 2.0)
                let fixed_left_flow_right = right
                
                let previous_fall_left = Fall(x: conveyor.x2, amount: previous_flow_right)
                let fixed_left_fall_left = Fall(x: conveyor.x2, amount: fixed_left_flow_right)
                
                let adjustment_right = -(right_collider.full_cost(fall: previous_fall_left))
                let adjustment_left = right_collider.full_cost(fall: fixed_left_fall_left)
                
                improvements_if_we_fix_right += adjustment_right
                improvements_if_we_fix_left += adjustment_left
            }
            
            print("\(conveyor.name) fall \(fall.x), \(fall.amount) improvements_if_we_fix_right = \(improvements_if_we_fix_right)")
            print("\(conveyor.name) fall \(fall.x), \(fall.amount) improvements_if_we_fix_left = \(improvements_if_we_fix_left)")
            
            
        }
        
        
        if improvements_if_we_fix_left > result_score {
            result_conveyor = conveyor
            result_direction = .left
            result_score = improvements_if_we_fix_left
        }
        
        if improvements_if_we_fix_right > result_score {
            result_conveyor = conveyor
            result_direction = .right
            result_score = improvements_if_we_fix_right
        }
        
    }
    
    let result = VeryBestOne(conveyor: result_conveyor, direction: result_direction)
    return result
}
