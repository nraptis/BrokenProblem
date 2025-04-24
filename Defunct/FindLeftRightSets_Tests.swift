//
//  FindLeftRightSets_Tests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

class FindLeftRightSets_Tests {
    
    static func test_example_a() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 5, x2: 35, y: 50)
        
        //             [    c1     ]
        //         [   c0  ]
        //     [             c2         ]
        //
        // 00  05  10  15  20  25  30  35  40
        
        let conveyors = [c0, c1, c2]
        
        
        let expected_c2_left_set: Set<Conveyor> = []
        let expected_c2_right_set: Set<Conveyor> = []
        
        let expected_c0_left_set: Set<Conveyor> = []
        let expected_c0_right_set: Set<Conveyor> = []
        
        let expected_c1_left_set: Set<Conveyor> = [c0, c2]
        let expected_c1_right_set: Set<Conveyor> = [c2]
        
        findColliders(conveyors: conveyors)
        findParentsAndRoot(conveyors: conveyors)
        findLeftRightSets(conveyors: conveyors)
        
        if c0.left_set != expected_c0_left_set {
            print("test_example_a: Failed c0.left_set")
            print(c0.left_set)
            print(expected_c0_left_set)
            return
        }
        
        if c0.right_set != expected_c0_right_set {
            print("test_example_a: Failed c0.right_set")
            print(c0.right_set)
            print(expected_c0_right_set)
            return
        }
        
        if c1.left_set != expected_c1_left_set {
            print("test_example_a: Failed c1.left_set")
            print(c1.left_set)
            print(expected_c1_left_set)
            return
        }
        
        if c1.right_set != expected_c1_right_set {
            print("test_example_a: Failed c1.right_set")
            print(c1.right_set)
            print(expected_c1_right_set)
            return
        }
        
        if c2.left_set != expected_c2_left_set {
            print("test_example_a: Failed c2.left_set")
            print(c2.left_set)
            print(expected_c2_left_set)
            return
        }
        
        if c2.right_set != expected_c2_right_set {
            print("test_example_a: Failed c2.right_set")
            print(c2.right_set)
            print(expected_c2_right_set)
            return
        }
        
        print("Passed All!")
    }
    
}
