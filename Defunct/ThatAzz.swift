//
//  ThatAzz.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/25/25.
//

import Foundation

func getFallCostRight(x: Int,
                      conveyor: Conveyor,
                      collider: Conveyor) -> Double {
    let cost_lhs = Double(abs(collider.x2 - x))
    let cost_rhs = getFallCostRight(conveyor: collider)
    let result = cost_lhs + cost_rhs
    return result
}

func getFallCostLeft(x: Int,
                     conveyor: Conveyor,
                     collider: Conveyor) -> Double {
    let cost_lhs = Double(abs(x - collider.x1))
    let cost_rhs = getFallCostLeft(conveyor: collider)
    let result = cost_lhs + cost_rhs
    return result
}

func getFallCostRight(conveyor: Conveyor) -> Double {
    
    if let right_collider = conveyor.right_collider {

            let left_cost = getFallCostLeft(x: conveyor.x2,
                                            conveyor: conveyor,
                                            collider: right_collider)
            let right_cost = getFallCostRight(x: conveyor.x2,
                                              conveyor: conveyor,
                                              collider: right_collider)
            let result = (left_cost + right_cost) / 2.0
        
            return result
        
        
    } else {
        let result = Double(0.0)
        return result
    }
}

func getFallCostLeft(conveyor: Conveyor) -> Double {
    
    if let left_collider = conveyor.left_collider {
        
        let left_cost = getFallCostLeft(x: conveyor.x1,
                                        conveyor: conveyor,
                                        collider: left_collider)
        let right_cost = getFallCostRight(x: conveyor.x1,
                                          conveyor: conveyor,
                                          collider: left_collider)
        let result = (left_cost + right_cost) / 2.0
        
        return result
        
    } else {
        let result = Double(0.0)
        
        return result
    }
}
