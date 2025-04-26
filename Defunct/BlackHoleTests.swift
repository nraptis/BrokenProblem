//
//  BlackHoleTests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/25/25.
//

import Foundation

/*
func ingest_fall_black_hole_original(black_hole_mass: Double,
                                     black_hole_distance: Double,
                                     black_hole_center: Double) {
    
    let fall_black_hole = DropBlackHole(x: black_hole_center,
                                        distance: black_hole_distance,
                                        mass: black_hole_mass)
    fall_black_holes_original.append(fall_black_hole)

    if let left_collider = left_collider {
        left_collider.ingest_fall_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                      black_hole_distance: black_hole_distance + black_hole_center - Double(x1),
                                                      black_hole_center: Double(x1))
    }
    if let right_collider = right_collider {
        right_collider.ingest_fall_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                       black_hole_distance: black_hole_distance + Double(x2) - black_hole_center,
                                                       black_hole_center: Double(x2))
    }
}
*/



/*
func findBlackHoles(conveyors: [Conveyor]) {
    let conveyors = conveyors.sorted { $0.y > $1.y }
    for conveyor in conveyors {
        for drop_span in conveyor.drop_spans {
            let mass = Conveyor.mass(span: drop_span)
            let x = Conveyor.center(span: drop_span)
            let drop_black_hole = DropBlackHole(x: x,
                                                distance: 0.0,
                                                mass: mass)
            conveyor.mixed_black_holes_original.append(drop_black_hole)
        }
        
        if let right_collider = conveyor.right_collider {
            var right_black_holes = [DropBlackHole]()
            for drop_span in conveyor.drop_spans {
                let mass = Conveyor.mass(span: drop_span) / 2.0
                let x = Conveyor.center(span: drop_span)
                let disance = Double(conveyor.x2) - x
                let drop_black_hole = DropBlackHole(x: x,
                                                    distance: disance,
                                                    mass: mass)
                right_black_holes.append(drop_black_hole)
            }
            var combined_mass = Double(0.0)
            var combined_distance = Double(0.0)
            for black_hole in right_black_holes {
                combined_mass += black_hole.mass
                combined_distance += (black_hole.distance * black_hole.mass)
            }
            if combined_mass > 0.05 {
                if combined_distance > 0.05 {
                    combined_distance /= combined_mass
                    right_collider.ingest_fall_black_hole_original(black_hole_mass: combined_mass,
                                                                   black_hole_distance: combined_distance,
                                                                   black_hole_center: Double(conveyor.x2))
                }
            }
        }
        
        if let left_collider = conveyor.left_collider {
            var left_black_holes = [DropBlackHole]()
            for drop_span in conveyor.drop_spans {
                let mass = Conveyor.mass(span: drop_span) / 2.0
                let x = Conveyor.center(span: drop_span)
                let disance = x - Double(conveyor.x1)
                let drop_black_hole = DropBlackHole(x: x,
                                                    distance: disance,
                                                    mass: mass)
                left_black_holes.append(drop_black_hole)
            }
            var combined_mass = Double(0.0)
            var combined_distance = Double(0.0)
            
            for black_hole in left_black_holes {
                combined_mass += black_hole.mass
                combined_distance += (black_hole.distance * black_hole.mass)
            }
            
            if combined_mass > 0.05 {
                if combined_distance > 0.05 {
                    combined_distance /= combined_mass
                    left_collider.ingest_fall_black_hole_original(black_hole_mass: combined_mass,
                                                                  black_hole_distance: combined_distance,
                                                                  black_hole_center: Double(conveyor.x2))
                }
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
*/

func ingest_cozts(conveyors: [Conveyor]) {
    
    let conveyors = conveyors.sorted { $0.y > $1.y }
    
    /*
    var cozt_left = Double(0.0)
    var cozt_right = Double(0.0)
    var cozt_random = Double(0.0)
    */
    for conveyor in conveyors {
        
        let remaining_movement_left = conveyor.remaining_movement_left
        let remaining_movement_right = conveyor.remaining_movement_right
        let remaining_movement_random = (remaining_movement_left + remaining_movement_right) / 2.0
        
        for drop_span in conveyor.drop_spans {
            let black_hole_mass = Conveyor.mass(span: drop_span)
            let black_hole_center = Conveyor.center(span: drop_span)
            
            
            /*
            let drop_black_hole = DropBlackHole(x: x,
                                                distance: 0.0,
                                                mass: mass)
            conveyor.mixed_black_holes_original.append(drop_black_hole)
            */
            
            
            
            let distance_left = conveyor.distance_left(x: black_hole_center) + remaining_movement_left
            let distance_right = conveyor.distance_right(x: black_hole_center) + remaining_movement_right
            let distance_random = conveyor.distance_random(x: black_hole_center) + remaining_movement_random
            
            conveyor.cozt_left += black_hole_mass * distance_left
            conveyor.cozt_right +=  black_hole_mass * distance_right
            conveyor.cozt_random += black_hole_mass * distance_random
            
            
            if let left_collider = conveyor.left_collider {
                left_collider.ingest_cozts(black_hole_mass: black_hole_mass / 2.0,
                                                              black_hole_distance: black_hole_center - Double(conveyor.x1),
                                                              black_hole_center: Double(conveyor.x1))
            }
            if let right_collider = conveyor.right_collider {
                right_collider.ingest_cozts(black_hole_mass: black_hole_mass / 2.0,
                                                               black_hole_distance: Double(conveyor.x2) - black_hole_center,
                                                               black_hole_center: Double(conveyor.x2))
            }
        }
    }
    
}
