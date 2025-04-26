//
//  Runner.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

struct Runner {
    
    static func test_example_1() {
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 600000, y: 10)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 800000, y: 20)
        let conveyors = [c_0, c_1]
        let result = getMinExpectedHorizontalTravelDistance(conveyors: conveyors)
        print("test_example_1 => \(result)")
    }
    
    static func test_example_2() {
        let c_0 = Conveyor(index: 0, x1: 5000, x2: 7000, y: 2)
        let c_1 = Conveyor(index: 1, x1: 2000, x2: 8000, y: 8)
        let c_2 = Conveyor(index: 2, x1: 7000, x2: 11000, y: 5)
        let c_3 = Conveyor(index: 3, x1: 9000, x2: 11000, y: 9)
        let c_4 = Conveyor(index: 4, x1: 0, x2: 4000, y: 4)
        let conveyors = [c_0, c_1, c_2, c_3, c_4]
        let result = getMinExpectedHorizontalTravelDistance(conveyors: conveyors)
        print("test_example_2 => \(result)")
    }
    
    static func run() {
        test_example_1()
        test_example_2()
        Cumulator_Test.test_tiny_example_000()
        Cumulator_Test.test_tiny_example_001()
        Cumulator_Test.test_tiny_example_002()
        Cumulator_Test.test_double_example_000()
        BruteTests.test_1000_2_conveyor()
        BruteTests.test_1000_3_conveyor()
        BruteTests.test_1000_4_conveyor()
        BruteTests.test_1000_5_conveyor()
        BruteTests.test_1000_6_conveyor()
    }
}
