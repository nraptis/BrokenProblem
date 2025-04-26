//
//  Mass.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/25/25.
//

import Foundation

struct DropBlackHole: Hashable, Equatable {
    let x: Double
    let distance: Double
    let mass: Double
    init(x: Double, distance: Double, mass: Double) {
        if mass <= 0 {
            fatalError("A black hole cannot have a mass less than or equal to zero.")
        }
        self.x = x
        self.distance = distance
        self.mass = mass
    }
    
    func crush() -> Double {
        return BlackHole.crush(distance: distance, mass: mass)
    }
    
    func crush(distance: Double) -> Double {
        return BlackHole.crush(distance: distance + self.distance, mass: mass)
    }
    
}

struct BlackHole: Hashable, Equatable {
    let distance: Double
    let mass: Double
    init(distance: Double, mass: Double) {
        if mass <= 0 {
            fatalError("A black hole cannot have a mass less than or equal to zero.")
        }
        self.distance = distance
        self.mass = mass
    }
    
    func crush() -> Double {
        return BlackHole.crush(distance: distance, mass: mass)
    }
    
    func crush(distance: Double) -> Double {
        return BlackHole.crush(distance: distance + self.distance, mass: mass)
    }
    
    static func crush(distance: Double, mass: Double) -> Double {
        return (distance * mass) / 1_000_000.0
    }
}

func findBlackHoles(conveyors: [Conveyor]) {
    
    let conveyors = conveyors.sorted { $0.y > $1.y }
    
    for conveyor in conveyors {
        print("B-Hole candidate:\(conveyor)")
    }
    
    for conveyor in conveyors {
        for drop_span in conveyor.drop_spans {
            
            let black_hole_mass = Conveyor.mass(span: drop_span)
            let distance_left = conveyor.distance_left(span: drop_span)
            let distance_right = conveyor.distance_right(span: drop_span)
            let distance_random = conveyor.distance_random(span: drop_span)
            
            let black_hole_fixed_left = BlackHole(distance: distance_left, mass: black_hole_mass)
            conveyor.black_holes_fixed_left.append(black_hole_fixed_left)
            
            let black_hole_fixed_right = BlackHole(distance: distance_right, mass: black_hole_mass)
            conveyor.black_holes_fixed_right.append(black_hole_fixed_right)
            
            let black_hole_random = BlackHole(distance: distance_random, mass: black_hole_mass)
            conveyor.black_holes_random.append(black_hole_random)
            
            if let left_collider = conveyor.left_collider {
                left_collider.ingest_drop_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                              black_hole_distance: distance_left,
                                                              black_hole_center: Double(conveyor.x1))
            }
            
            if let right_collider = conveyor.right_collider {
                right_collider.ingest_drop_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                               black_hole_distance: distance_right,
                                                               black_hole_center: Double(conveyor.x2))
            }
        }
        
        // These ones bubble down too...
        for drop_black_hole in conveyor.drop_black_holes_original {
            let black_hole_mass = drop_black_hole.mass
            let distance_left = conveyor.distance_left(drop_black_hole: drop_black_hole)
            let distance_right = conveyor.distance_right(drop_black_hole: drop_black_hole)
            let distance_random = conveyor.distance_random(drop_black_hole: drop_black_hole)
            
            let black_hole_fixed_left = BlackHole(distance: distance_left, mass: black_hole_mass)
            conveyor.black_holes_fixed_left.append(black_hole_fixed_left)
            
            let black_hole_fixed_right = BlackHole(distance: distance_right, mass: black_hole_mass)
            conveyor.black_holes_fixed_right.append(black_hole_fixed_right)
            
            let black_hole_random = BlackHole(distance: distance_random, mass: black_hole_mass)
            conveyor.black_holes_random.append(black_hole_random)
            
            if let left_collider = conveyor.left_collider {
                left_collider.ingest_drop_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                              black_hole_distance: distance_left,
                                                              black_hole_center: Double(conveyor.x1))
            }
            
            if let right_collider = conveyor.right_collider {
                right_collider.ingest_drop_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                               black_hole_distance: distance_right,
                                                               black_hole_center: Double(conveyor.x2))
            }
        }
    }
    
    for conveyor in conveyors {
        print("B-Hole :\(conveyor), All Black Goles ====>")
        print("\tFixed Left =>")
        for black_hole in conveyor.black_holes_fixed_left {
            print("\t\t\(black_hole)")
        }
        print("\tFixed Right =>")
        for black_hole in conveyor.black_holes_fixed_right {
            print("\t\t\(black_hole)")
        }
        print("\tRandom =>")
        for black_hole in conveyor.black_holes_random {
            print("\t\t\(black_hole)")
        }
        
    }
    
    
    
}
