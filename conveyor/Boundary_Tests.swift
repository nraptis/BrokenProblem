//
//  Boundary_Tests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

struct Boundary_Tests {
    
    static func run_closed_closed() {
        let test1_boundary1 = Boundary.closed(10)
        let test1_boundary2 = Boundary.closed(10)
        if test1_boundary1 != test1_boundary2 { print("[run_closed_closed] Test failed, (test1_boundary1 != test1_boundary2)") }
        
        let test2_boundary1 = Boundary.closed(11)
        let test2_boundary2 = Boundary.closed(10)
        if test2_boundary1 == test2_boundary2 { print("[run_closed_closed] Test failed, (test2_boundary1 == test2_boundary2)") }
        
        let test3_boundary1 = Boundary.closed(10)
        let test3_boundary2 = Boundary.closed(11)
        if test3_boundary1 == test3_boundary2 { print("[run_closed_closed] Test failed, (test3_boundary1 == test3_boundary2)") }
    }
    
    static func run_closed_open() {
        let test1_boundary1 = Boundary.closed(10)
        let test1_boundary2 = Boundary.open(10)
        if test1_boundary1 == test1_boundary2 { print("[run_closed_open] Test failed, (test1_boundary1 == test1_boundary2)") }
        
        let test2_boundary1 = Boundary.closed(11)
        let test2_boundary2 = Boundary.open(10)
        if test2_boundary1 == test2_boundary2 { print("[run_closed_open] Test failed, (test2_boundary1 == test2_boundary2)") }
        
        let test3_boundary1 = Boundary.closed(10)
        let test3_boundary2 = Boundary.open(11)
        if test3_boundary1 == test3_boundary2 { print("[run_closed_open] Test failed, (test3_boundary1 == test3_boundary2)") }
    }
    
    static func run_open_closed() {
        let test1_boundary1 = Boundary.open(10)
        let test1_boundary2 = Boundary.closed(10)
        if test1_boundary1 == test1_boundary2 { print("[run_open_closed] Test failed, (test1_boundary1 == test1_boundary2)") }
        
        let test2_boundary1 = Boundary.open(11)
        let test2_boundary2 = Boundary.closed(10)
        if test2_boundary1 == test2_boundary2 { print("[run_open_closed] Test failed, (test2_boundary1 == test2_boundary2)") }
        
        let test3_boundary1 = Boundary.open(10)
        let test3_boundary2 = Boundary.closed(11)
        if test3_boundary1 == test3_boundary2 { print("[run_open_closed] Test failed, (test3_boundary1 == test3_boundary2)") }
    }
    
    static func run_open_open() {
        let test1_boundary1 = Boundary.open(10)
        let test1_boundary2 = Boundary.open(10)
        if test1_boundary1 != test1_boundary2 { print("[run_open_open] Test failed, (test1_boundary1 != test1_boundary2)") }
        
        let test2_boundary1 = Boundary.open(11)
        let test2_boundary2 = Boundary.open(10)
        if test2_boundary1 == test2_boundary2 { print("[run_open_open] Test failed, (test2_boundary1 == test2_boundary2)") }
        
        let test3_boundary1 = Boundary.open(10)
        let test3_boundary2 = Boundary.open(11)
        if test3_boundary1 == test3_boundary2 { print("[run_open_open] Test failed, (test3_boundary1 == test3_boundary2)") }
    }
    
}
