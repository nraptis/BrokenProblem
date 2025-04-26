//
//  Cumulator_Test.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/26/25.
//

import Foundation

class Cumulator_Test {
    
    static func test_tiny_example_000() {
        
        let a = DropBlackHole(x: 0.0, distance: 31.0, mass: 52.0)
        let b = DropBlackHole(x: 0.0, distance: 17.0, mass: 64.0)
        
        // We just want to combine a and b.
        
        let expected = (a.distance * a.mass) + (b.distance * b.mass)
        
        // Here is what I need help with. I would like to be able to combine a and b in this way.
        // The same math can go on to add a 3rd, 4th, and more.
        
        let combined_mass = a.mass + b.mass
        let combined_distance = (a.distance * a.mass + b.distance * b.mass) / combined_mass
        let a_b = DropBlackHole(x: 0.0, distance: combined_distance, mass: combined_mass)
        
        let result = (a_b.distance * a_b.mass)
        
        if expected != result {
            print("These did not combine how we imagined, expected \(expected) and got \(result)")
        } else {
            print("This worked perfectly, expected \(expected) and got \(result)")
        }
    }
    
    static func test_tiny_example_001() {
        
        let a = DropBlackHole(x: 0.0, distance: 31.0, mass: 52.0)
        let b = DropBlackHole(x: 0.0, distance: 17.0, mass: 64.0)
        let c = DropBlackHole(x: 0.0, distance: 29.0, mass: 13.0)
        
        // We just want to combine a and b.
        
        let expected = (a.distance * a.mass) + (b.distance * b.mass) + (c.distance * c.mass)
        
        // Here is what I need help with. I would like to be able to combine a and b in this way.
        // The same math can go on to add a 3rd, 4th, and more.
        
        let combined_mass = a.mass + b.mass + c.mass
        let combined_distance = (a.distance * a.mass + b.distance * b.mass + c.distance * c.mass) / combined_mass
        let a_b_c = DropBlackHole(x: 0.0, distance: combined_distance, mass: combined_mass)
        
        let result = (a_b_c.distance * a_b_c.mass)
        
        if expected != result {
            print("These did not combine how we imagined, expected \(expected) and got \(result)")
        } else {
            print("This worked perfectly, expected \(expected) and got \(result)")
        }
    }
    
    static func test_tiny_example_002() {
        
        let a = DropBlackHole(x: 0.0, distance: 31.0, mass: 52.0)
        let b = DropBlackHole(x: 0.0, distance: 17.0, mass: 64.0)
        let c = DropBlackHole(x: 0.0, distance: 29.0, mass: 13.0)
        let d = DropBlackHole(x: 0.0, distance: 71.0, mass: 28.0)
        
        
        // We just want to combine a and b.
        
        let expected = (a.distance * a.mass) + (b.distance * b.mass) + (c.distance * c.mass) + (d.distance * d.mass)
        
        // Here is what I need help with. I would like to be able to combine a and b in this way.
        // The same math can go on to add a 3rd, 4th, and more.
        
        let combined_mass = a.mass + b.mass + c.mass + d.mass
        let combined_distance = (a.distance * a.mass + b.distance * b.mass + c.distance * c.mass + d.distance * d.mass) / combined_mass
        let a_b_c_d = DropBlackHole(x: 0.0, distance: combined_distance, mass: combined_mass)
        
        let result = (a_b_c_d.distance * a_b_c_d.mass)
        
        if expected != result {
            print("These did not combine how we imagined, expected \(expected) and got \(result)")
        } else {
            print("This worked perfectly, expected \(expected) and got \(result)")
        }
    }
    
    static func test_double_example_000() {
        
        var a_0 = DropBlackHole(x: 0.0, distance: 13.0, mass: 27.0)
        var b_0 = DropBlackHole(x: 0.0, distance: 19.0, mass: 42.0)
        
        // a moves 24 units
        // b moves 61 units
        a_0.distance += 24.0
        b_0.distance += 61.0
        
        //
        // a and b both land in the same place, a level below
        // c is at this same place too.
        var c_0 = DropBlackHole(x: 0.0, distance: 51.0, mass: 32.0)
        
        // a, b, and x all move 16 units more
        a_0.distance += 16.0
        b_0.distance += 16.0
        c_0.distance += 16.0
        
        let final_cost_0 = (a_0.distance * a_0.mass) + (b_0.distance * b_0.mass) + (c_0.distance * c_0.mass)
        
        let a_1 = DropBlackHole(x: 0.0, distance: 13.0 + 24.0, mass: 27.0)
        let b_1 = DropBlackHole(x: 0.0, distance: 19.0 + 61.0, mass: 42.0)
        var c_1 = DropBlackHole(x: 0.0, distance: 51.0, mass: 32.0)
        
        let a_b_combined_mass = a_1.mass + b_1.mass
        let a_b_combined_distance = (a_1.distance * a_1.mass + b_1.distance * b_1.mass) / a_b_combined_mass
        
        var a_b = DropBlackHole(x: 0.0, distance: a_b_combined_distance, mass: a_b_combined_mass)
        a_b.distance += 16.0
        c_1.distance += 16.0
        
        let ab_c_combined_mass = a_b.mass + c_1.mass
        let ab_c_combined_distance = (a_b.distance * a_b.mass + c_1.distance * c_1.mass) / ab_c_combined_mass
        
        let final = DropBlackHole(x: 0, distance: ab_c_combined_distance, mass: ab_c_combined_mass)
        
        let final_cost_1 = (final.distance * final.mass)
        
        print("final_cost_0 = \(final_cost_0)")
        print("final_cost_1 = \(final_cost_1)")
    }
    
    
}
