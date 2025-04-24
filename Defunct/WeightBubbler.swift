//
//  WeightBubbler.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

func bubbleWeights(conveyors: [Conveyor], drops: [Drop]) {
    
    print("bubbleWeights ==> ==> ==>")
    
    print("8====>")
    for conveyor in conveyors {
        print("Convoy: \(conveyor)")
    }
    
    for conveyor in conveyors {
        conveyor.drop_count = 0
    }
    
    
    
    for drop in drops {
        switch drop {
        case .empty:
            break
        case .conveyor(let span, let conveyor):
            let count = Conveyor.count(span: span)
            conveyor.drop_count += count
        }
    }
    
    for conveyor in conveyors {
        conveyor.drop_weight = Double(conveyor.drop_count)
    }
    
    print("8====>")
    for conveyor in conveyors {
        print("Convoy: \(conveyor)")
        print("a=>drop_count = \(conveyor.drop_count)")
        print("a=>drop_weight = \(conveyor.drop_weight)")
        
    }
    
    // We go from the top-down...
    let conveyors = conveyors.sorted { $0.y > $1.y }
    
    print("8====>")
    for conveyor in conveyors {
        print("Dingus: \(conveyor)")
    }
    
    for conveyor in conveyors {
        if conveyor.drop_weight > 0.0 {
            if let right_collider = conveyor.right_collider {
                right_collider.drop_weight += (conveyor.drop_weight / 2.0)
            }
            if let left_collider = conveyor.left_collider {
                left_collider.drop_weight += (conveyor.drop_weight / 2.0)
            }
        }
    }
    
    print("8====>")
    for conveyor in conveyors {
        print("Convoy: \(conveyor.name)")
        print("b=>SMOOTHE = \(conveyor.drop_weight) | \(conveyor.drop_count)")
    }
    
    
}
