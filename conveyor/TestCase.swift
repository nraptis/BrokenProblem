//
//  TestCase.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

struct TestCase {
    let conveyors: [Conveyor]
    
    static var test_case_stepper_1: TestCase {
        let c0 = Conveyor(name: "c0", index: 0, x1: 0, x2: 4, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 5, x2: 10, y: 99)
        return TestCase(conveyors: [c0, c1])
    }
    
    static var test_case_1: TestCase {
        let c0 = Conveyor(name: "c0", index: 0, x1: 100_000, x2: 600_000, y: 10)
        let c1 = Conveyor(name: "c1", index: 1, x1: 400_000, x2: 800_000, y: 20)
        return TestCase(conveyors: [c0, c1])
    }
    
}
