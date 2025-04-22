//
//  FallCost_Uniform.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

// @Precondition: conveyor is the conveyor from which we fall
//                off of to-the-right, we do not include any
//                travel costs for the conveyor itself.

func findFallCostsUniform(conveyors: [Conveyor]) {
    for conveyor in conveyors {
        _ = findFallCostRight_Uniform(conveyor: conveyor)
        _ = findFallCostLeft_Uniform(conveyor: conveyor)
    }
}

func findFallCostLeft_Uniform(conveyor: Conveyor?) -> Double {
    
    guard let conveyor = conveyor else { return 0.0 }
    
    if conveyor.cost_left_uniform != Conveyor.INVALID {
        return conveyor.cost_left_uniform
    }
    
    if let left_collider = conveyor.left_collider {
        
        //              [.  c0.   ]
        //       [.   c1.   ]
        //   [.  c2.   ].  [.   c3.   ]
        
        // left_collider is c1
        
        let cost_right = Double(left_collider.x2 - conveyor.x1) + findFallCostRight_Uniform(conveyor: left_collider)
        let cost_left = Double(conveyor.x1 - left_collider.x1) + findFallCostLeft_Uniform(conveyor: left_collider)
        conveyor.cost_left_uniform = (cost_left + cost_right) * 0.5
        return conveyor.cost_left_uniform
    } else {
        conveyor.cost_left_uniform = 0.0
        return conveyor.cost_left_uniform
    }
}
func findFallCostRight_Uniform(conveyor: Conveyor?) -> Double {
    
    guard let conveyor = conveyor else { return 0.0 }
    
    if conveyor.cost_right_uniform != Conveyor.INVALID {
        return conveyor.cost_right_uniform
    }
    
    if let right_collider = conveyor.right_collider {
        
        //[.  c0.   ]
        //       [.   c1.   ]
        //   [.  c2.   ].  [.   c3.   ]
        
        // right_collider is c1
        
        let cost_right = Double(right_collider.x2 - conveyor.x2) + findFallCostRight_Uniform(conveyor: right_collider)
        let cost_left = Double(conveyor.x2 - right_collider.x1) + findFallCostLeft_Uniform(conveyor: right_collider)
        
        conveyor.cost_right_uniform = (cost_left + cost_right) * 0.5
        return conveyor.cost_right_uniform
        
    } else {
        conveyor.cost_right_uniform = 0.0
        return conveyor.cost_right_uniform
    }
}
