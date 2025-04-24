//
//  VeryBestOne.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/24/25.
//

import Foundation

struct VeryBestOne {
    let conveyor: Conveyor
    let direction: Direction
}

func findTheVeryBestOne(conveyors: [Conveyor]) -> VeryBestOne {
    
    var result_conveyor = conveyors[0]
    var result_direction = Direction.left
    var result_score = Double(-100_000_000.0)
    
    for conveyor in conveyors {
        
        let fall_cost_fixed_left = conveyor.fall_cost_fixed_left
        let fall_cost_fixed_right = conveyor.fall_cost_fixed_right
        let fall_cost_random = conveyor.fall_cost_random
        
        let improvement_left = (fall_cost_random - fall_cost_fixed_left)
        let improvement_right = (fall_cost_random - fall_cost_fixed_right)
        
        print("VeryBestOne, \(conveyor.name)")
        print("\tfall_cost_fixed_left = \(fall_cost_fixed_left)")
        print("\tfall_cost_fixed_right = \(fall_cost_fixed_right)")
        print("\tfall_cost_random = \(fall_cost_random)")
        print("\timprovement_left = \(improvement_left)")
        print("\timprovement_right = \(improvement_right)")
        
        if improvement_left > result_score {
            result_conveyor = conveyor
            result_direction = .left
            result_score = improvement_left
            print("new best conveyor is \(conveyor.name), going left, with score \(improvement_left)")
        }
        if improvement_right > result_score {
            result_conveyor = conveyor
            result_direction = .right
            result_score = improvement_right
            print("new best conveyor is \(conveyor.name), going right, with score \(improvement_right)")
        }
        
        
        
    }
    
    print("DONE! The very best conveyor is this: \(result_conveyor.name) with direction: \(result_direction)")
    
    
    let result = VeryBestOne(conveyor: result_conveyor, direction: result_direction)
    return result
}
