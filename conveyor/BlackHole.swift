//
//  Mass.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/25/25.
//

import Foundation

struct DropBlackHole {
    let x: Double
    let distance: Double
    let mass: Double
    init(x: Double,
         distance: Double,
         mass: Double) {
        self.x = x
        self.distance = distance
        self.mass = mass
    }
}

func findBlackHolesOriginal(conveyors: [Conveyor]) {
    
    let conveyors = conveyors.sorted { $0.y > $1.y }

    for conveyor in conveyors {
        
        
        for drop_span in conveyor.drop_spans {
            let mass = Conveyor.mass(span: drop_span)
            let x = Conveyor.center(span: drop_span)
            let drop_black_hole = DropBlackHole(x: x,
                                                distance: 0.0,
                                                mass: mass)
            conveyor.mixed_black_holes_original.append(drop_black_hole)
            
            if let left_collider = conveyor.left_collider {
                left_collider.ingest_fall_black_hole_original(black_hole_mass: mass / 2.0,
                                                              black_hole_distance: x - Double(conveyor.x1),
                                                              black_hole_center: Double(conveyor.x1))
            }
            if let right_collider = conveyor.right_collider {
                right_collider.ingest_fall_black_hole_original(black_hole_mass: mass / 2.0,
                                                               black_hole_distance: Double(conveyor.x2) - x,
                                                               black_hole_center: Double(conveyor.x2))
            }
        }
        
        for fall_black_hole in conveyor.fall_black_holes_original {
            let mass = fall_black_hole.mass
            let distance = fall_black_hole.distance
            let x = fall_black_hole.x
            let copy_black_hole = DropBlackHole(x: x, distance: distance, mass: mass)
            conveyor.mixed_black_holes_original.append(copy_black_hole)
        }
    }

    
}
