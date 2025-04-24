//
//  FallOffCosts.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/23/25.
//

import Foundation

func findFallSums(conveyors: [Conveyor]) {
    let DEBUG = true
    
    
    let conveyors = conveyors.sorted { $0.y > $1.y }
    for conveyor in conveyors {

        var fall_sum_left = Double(0.0)
        var fall_sum_right = Double(0.0)
        
        for span in conveyor.dropSpans {
            let cost_left = conveyor.average_left(span: span)
            let cost_right = conveyor.average_right(span: span)
            fall_sum_left += Double(cost_left) / 2.0
            fall_sum_right += Double(cost_right) / 2.0
            
        }
        
        for fall in conveyor.falls {
            let distance_left = (fall.x - conveyor.x1)
            let distance_right = (conveyor.x2 - fall.x)
            fall_sum_left += fall.amount + Double(distance_left) / 2.0
            fall_sum_right += fall.amount + Double(distance_right) / 2.0
        }
        
        conveyor.fall_sum_left = fall_sum_left
        conveyor.fall_sum_right = fall_sum_right
        
        if let left_collider = conveyor.left_collider {
            let fall = Fall(x: conveyor.x1, amount: fall_sum_left)
            left_collider.falls.append(fall)
        }
        
        if let right_collider = conveyor.right_collider {
            let fall = Fall(x: conveyor.x2, amount: fall_sum_right)
            right_collider.falls.append(fall)
        }
        
        
    }
    
    
    if DEBUG {
        print("</ Start With FindFallSums>")
        for conveyor in conveyors {
            print("Con: \(conveyor.name)")
            print("\tfsl: \(conveyor.fall_sum_left)")
            print("\tfsr: \(conveyor.fall_sum_right)")
            
        }
        print("</ Done With FindFallSums>")
    }
}

func findFalls(conveyors: [Conveyor]) {
    
    let DEBUG = true
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
            let add_aver = (add_left + add_right) / 2.0
            fall_cost_fixed_left += add_left
            fall_cost_fixed_right += add_right
            fall_cost_random_left += add_left
            fall_cost_random_right += add_left
        }
        
        for fall in conveyor.falls {
            let travel_left = Double(fall.x - conveyor.x1)
            let travel_right = Double(conveyor.x2 - fall.x)
            let add_left = (fall.amount + travel_left)
            let add_right = (fall.amount + travel_right)
            let add_aver = (add_left + add_right) / 2.0
            fall_cost_fixed_left += add_left
            fall_cost_fixed_right += add_right
            fall_cost_random_left += add_left
            fall_cost_random_right += add_left
        }
        
        let fall_cost_random = (fall_cost_fixed_left + fall_cost_fixed_right) / 2.0
        
        conveyor.fall_cost_fixed_left = fall_cost_fixed_left
        conveyor.fall_cost_fixed_right = fall_cost_fixed_right
        conveyor.fall_cost_random = fall_cost_random
    }
    
    if DEBUG {
        print("</ Start With FindFalls>")
        print(">>> Spans >>>")
        for conveyor in conveyors {
            print("Conveyor: \(conveyor.name), \(conveyor.dropSpans.count) dropSpans")
            print("\tfall_cost_fixed_left=\(conveyor.fall_cost_fixed_left)")
            print("\tfall_cost_fixed_right=\(conveyor.fall_cost_fixed_right)")
            print("\tfall_cost_random=\(conveyor.fall_cost_random)")
        }
        print("</ Done With FindFalls>")
    }
    
}

/*
func findFalloffCosts(conveyors: [Conveyor]) {
    
    let conveyors = conveyors.sorted { $0.y > $1.y }
    
    
    
    
    
    for conveyor in conveyors {
        
        var fall_move_cost_left = Double(0.0)
        var fall_move_cost_right = Double(0.0)
        var fall_weight_sum = Double(0.0)
        
        for fall_bag_node in conveyor.fall_bag.list {
            
            let weight = fall_bag_node.weight
            let move_left = (fall_bag_node.x - conveyor.x1)
            let move_right = (conveyor.x2 - fall_bag_node.x)
            
            
            fall_move_cost_left += fall_bag_node.weight + Double(move_left)
            fall_move_cost_right += fall_bag_node.weight + Double(move_right)
            
            fall_weight_sum += weight
            
            print("@ Con \(conveyor.name), weight: \(weight), move_left: \(move_left), move_right: \(move_right)")
            
        }
        
        let drop_cost_left = conveyor.drop_cost_left
        let drop_cost_right = conveyor.drop_cost_right
        
        
        conveyor.drip_even_distribution = fall_weight_sum + (drop_cost_left + drop_cost_right) / 2.0
        conveyor.drip_fixed_left = fall_weight_sum + drop_cost_left
        conveyor.drip_fixed_right = fall_weight_sum + drop_cost_right
        
        print("Fresh Calc! \(conveyor.name)")
        print("drip_even_distribution => \(conveyor.drip_even_distribution)")
        print("drip_fixed_left => \(conveyor.drip_fixed_left)")
        print("drip_fixed_right => \(conveyor.drip_fixed_right)")
        
        
        if let left_collider = conveyor.left_collider {
            let weight = conveyor.drip_even_distribution
            left_collider.fall_bag.record(x: conveyor.x1, weight: weight)
        }
        
        if let right_collider = conveyor.right_collider {
            let weight = conveyor.drip_even_distribution
            right_collider.fall_bag.record(x: conveyor.x2, weight: weight)
        }
        
    }
    
    for conveyor in conveyors {
        print("Conveyor: \(conveyor.name)")
        conveyor.fall_bag.printme(name: "\(conveyor.name)")
        
    }
    
    for conveyor in conveyors {
        print("Conveyor: \(conveyor.name) ===>")
        
        print("drip_even_distribution: \(conveyor.drip_even_distribution) ===>")
        print("drip_fixed_left: \(conveyor.drip_fixed_left) ===>")
        print("drip_fixed_right: \(conveyor.drip_fixed_right) ===>")
        
    }
    
    print("aluettay")
    
}
*/


