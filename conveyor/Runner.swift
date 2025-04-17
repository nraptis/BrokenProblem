//
//  Runner.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

struct Runner {
    
    static func run() {
        
        /*
        //
        //
        //
        //  [            ]                             y = 30
        //
        //                      [           ]          y = 20
        //
        //          [                   ]              y = 10
        //
        //
        //  10  20  30  40  50  60  70  80  90  100
        
        
        let testCase_a = TestCase(N: 3, H: [30, 20, 10], A: [10, 60, 30], B: [40, 90, 80])
        let result_a = getMinExpectedHorizontalTravelDistance(testCase_a)
        print("resulta = \(result_a)")
        
        
        
        //
        //
        //
        //  [            ]                             y = 30
        //
        //          [                   ]              y = 20
        //
        //                      [           ]          y = 10
        //
        //
        //  10  20  30  40  50  60  70  80  90  100
        
        
        let testCase_b = TestCase(N: 3, H: [30, 20, 10], A: [10, 30, 60], B: [40, 80, 90])
        let result_b = getMinExpectedHorizontalTravelDistance(testCase_b)
        print("resultb = \(result_b)")
        
        
        //
        //
        //
        //                      [           ]          y = 30
        //
        //          [                   ]              y = 20
        //
        //  [            ]                             y = 10
        //
        //
        //  10  20  30  40  50  60  70  80  90  100
        
        
        let testCase_c = TestCase(N: 3, H: [30, 20, 10], A: [60, 30, 10], B: [90, 40, 80])
        let result_c = getMinExpectedHorizontalTravelDistance(testCase_c)
        print("resultc = \(result_c)")
        */
        
        let testCase_1 = TestCase(N: 2, H: [10, 20], A: [100000, 400000], B: [600000, 800000])
        let result_1 = getMinExpectedHorizontalTravelDistance(testCase_1)
        print("result1 = \(result_1)")
        print("YAYAYAYAYAY!! Case One Done!!")
        
        
        /*
        let testCase_2 = TestCase(N: 5, H: [2, 8, 5, 9, 4], A: [5000, 2000, 7000, 9000, 0], B: [7000, 8000, 11000, 11000, 4000])
        let result_2 = getMinExpectedHorizontalTravelDistance(testCase_2)
        print("result2 = \(result_2)")
        */
    }
}
