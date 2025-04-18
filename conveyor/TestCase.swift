//
//  TestCase.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

struct TestCase {
    let conveyors: [Conveyor]
    
    static var test_case_1: TestCase {
        let conveyor_1 = Conveyor(index: 0, x1: 100_000, x2: 600_000, y: 10)
        let conveyor_2 = Conveyor(index: 1, x1: 400_000, x2: 800_000, y: 20)
        return TestCase(conveyors: [conveyor_1, conveyor_2])
    }
    
    static var test_case_1_b: TestCase {
        let conveyor_1 = Conveyor(index: 0, x1: 100_000, x2: 600_000, y: 20)
        let conveyor_2 = Conveyor(index: 1, x1: 400_000, x2: 800_000, y: 10)
        return TestCase(conveyors: [conveyor_1, conveyor_2])
    }
    
    
    static var test_case_3: TestCase {
        let conveyor_1 = Conveyor(index: 0, x1: 100_000, x2: 300_000, y: 20)
        let conveyor_2 = Conveyor(index: 0, x1: 500_000, x2: 700_000, y: 20)
        let conveyor_3 = Conveyor(index: 1, x1: 200_000, x2: 600_000, y: 10)
        return TestCase(conveyors: [conveyor_1, conveyor_2, conveyor_3])
    }
    
    static var test_case_4: TestCase {
        let conveyor_1 = Conveyor(index: 0, x1: 100_000, x2: 300_000, y: 20)
        let conveyor_2 = Conveyor(index: 0, x1: 500_000, x2: 700_000, y: 20)
        let conveyor_3 = Conveyor(index: 1, x1: 000_000, x2: 800_000, y: 10)
        return TestCase(conveyors: [conveyor_1, conveyor_2, conveyor_3])
    }
    
    
    static var test_case_a: TestCase {
        // VISUAL REPRESENTATION
        //
        //   y = 2     [---- conv_1 ----][---- conv_3 ----]
        //             x = 1        x = 3               x = 5
        //
        //   y = 1         [------- conv_2 -------]
        //                 x = 1             x = 4
        //
        //   x-axis:   0   1   2   3   4   5   6

        let conv_1 = Conveyor(index: 0, x1: 1, x2: 3, y: 2)  // (1, 3)
        let conv_2 = Conveyor(index: 1, x1: 1, x2: 4, y: 1)  // (1, 4)
        let conv_3 = Conveyor(index: 2, x1: 3, x2: 5, y: 2)  // (3, 5)

        let result = TestCase(conveyors: [conv_1, conv_2, conv_3])

        // EXPECTED RESULTS (assuming continuous x ~ Uniform(a, b), and transport to one endpoint):

        // conv_1: (1, 3)
        //  - left average:  (a + b)/2 - x1 = (1 + 3)/2 - 1 = 1.0
        //  - right average: x2 - (a + b)/2 = 3 - (1 + 3)/2 = 1.0

        // conv_2: (1, 4)
        //  - left average:  (a + b)/2 - x1 = (1 + 4)/2 - 1 = 1.5
        //  - right average: x2 - (a + b)/2 = 4 - (1 + 4)/2 = 1.5

        // conv_3: (3, 5)
        //  - left average:  (a + b)/2 - x1 = (3 + 5)/2 - 3 = 1.0
        //  - right average: x2 - (a + b)/2 = 5 - (3 + 5)/2 = 1.0

        return result
    }
    
    
}
