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
    
    static var test_case_large: TestCase {
        
        // y = 9, good
        // x1 = 1_000, good
        // x2 = 3_000, good
        let c0 = Conveyor(name: "c0", index: 0, x1: 1_000, x2: 3_000, y: 9)
        
        // y = 10, good
        // x1 = 6000, good
        // x2 = 10000, good
        let c1 = Conveyor(name: "c1", index: 1, x1: 6_000, x2: 10_000, y: 10)
        
        // y = 8, good
        // x1 = 2000, good
        // x2 = 8000, good
        let c2 = Conveyor(name: "c2", index: 2, x1: 2_000, x2: 8_000, y: 8)
        
        // y = 7, good
        // x1 = 7000, good
        // x2 = 11000, good
        let c3 = Conveyor(name: "c3", index: 3, x1: 7_000, x2: 11_000, y: 7)
        
        // y = 5, good
        // x1 = 5000, good
        // x2 = 9000, good
        let c4 = Conveyor(name: "c4", index: 4, x1: 5_000, x2: 9_000, y: 5)
        
        // y = 6, good
        // x1 = 10000, good
        // x2 = 12000, good
        let c5 = Conveyor(name: "c5", index: 5, x1: 10_000, x2: 12_000, y: 6)
        
        // y = 4, good
        // x1 = 9000, good
        // x2 = 11000, good
        let c6 = Conveyor(name: "c6", index: 6, x1: 9_000, x2: 11_000, y: 4)
        
        // y = 2, good
        // x1 = 5000, good
        // x2 = 7000, good
        let c7 = Conveyor(name: "c7", index: 7, x1: 5_000, x2: 7_000, y: 2)
        
        // y = 1, good
        // x1 = 8000, good
        // x2 = 14000, good
        let c8 = Conveyor(name: "c8", index: 8, x1: 8_000, x2: 14_000, y: 1)
        
        // y = 9, good
        // x1 = 11000, good
        // x2 = 13000, good
        let c9 = Conveyor(name: "c9", index: 9, x1: 11_000, x2: 13_000, y: 9)
        
        
        /*
        {c0, [1000 to 3000, y=9]}
        {c1, [6000 to 10000, y=10]}
        {c2, [2000 to 8000, y=8]}
        There's a Hit Bag At 3000 for c2
            hit from conveyor: c0
            hit count is: 2000
        There's a Hit Bag At 6000 for c2
            hit from conveyor: c1
            hit count is: 4000
        {c3, [7000 to 11000, y=7]}
        There's a Hit Bag At 10000 for c3
            hit from conveyor: c1
            hit count is: 4000
        There's a Hit Bag At 8000 for c3
            hit from conveyor: c2
            hit count is: 9000
        {c4, [5000 to 9000, y=5]}
        There's a Hit Bag At 7000 for c4
            hit from conveyor: c3
            hit count is: 14000
        {c5, [10000 to 12000, y=6]}
        There's a Hit Bag At 11000 for c5
            hit from conveyor: c9
            hit count is: 2000
            hit from conveyor: c3
            hit count is: 14000
        {c6, [9000 to 11000, y=4]}
        There's a Hit Bag At 10000 for c6
            hit from conveyor: c5
            hit count is: 16000
        {c7, [5000 to 7000, y=2]}
        {c8, [8000 to 14000, y=3]}
        There's a Hit Bag At 9000 for c8
            hit from conveyor: c6
            hit count is: 16000
            hit from conveyor: c4
            hit count is: 14000
        There's a Hit Bag At 13000 for c8
            hit from conveyor: c9
            hit count is: 2000
        There's a Hit Bag At 11000 for c8
            hit from conveyor: c6
            hit count is: 16000
        There's a Hit Bag At 12000 for c8
            hit from conveyor: c5
            hit count is: 16000
        {c9, [11000 to 13000, y=9]}
        */
        return TestCase(conveyors: [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9])
    }
    
    static var test_case_five_banger: TestCase {
        
        // Top Row.
        // c0, (1000 to 4000, y = 10)
        let c0 = Conveyor(name: "c0", index: 0, x1: 4_000, x2: 5_000, y: 10)
        // c1 (7000 to 10000, y = 10)
        let c1 = Conveyor(name: "c1", index: 1, x1: 7_000, x2: 10_000, y: 10)
        
        // Second Row.
        // c2, (2000 to 10000, y = 7)
        let c2 = Conveyor(name: "c2", index: 2, x1: 2_000, x2: 10_000, y: 7)
        
        
        // Third Row.
        // c3, (1000 to 6000, y = 4)
        let c3 = Conveyor(name: "c3", index: 3, x1: 1_000, x2: 6_000, y: 4)
        // c4, (9000 to 12000, y = 4)
        let c4 = Conveyor(name: "c4", index: 4, x1: 9_000, x2: 12_000, y: 4)
        
        
        // Fourth Row.
        // c5, (5000 to 13000, y = 1)
        let c5 = Conveyor(name: "c5", index: 5, x1: 3_000, x2: 11_000, y: 1)
        
        
        return TestCase(conveyors: [c0, c1, c2, c3, c4, c5])
    }
    
    static var test_case_stairs: TestCase {
        //test_case_stairs.png
        //test_case_stairs_drops.png
        let c0 = Conveyor(name: "c0", index: 0, x1: 1_000, x2: 4_000, y: 10)
        let c1 = Conveyor(name: "c1", index: 1, x1: 2_000, x2: 8_000, y: 7)
        let c2 = Conveyor(name: "c2", index: 2, x1: 5_000, x2: 9_000, y: 4)
        let c3 = Conveyor(name: "c3", index: 3, x1: 8_000, x2: 12_000, y: 1)
        return TestCase(conveyors: [c0, c1, c2, c3])
    }
    
    static var test_case_stairs_inverted: TestCase {
        let c0 = Conveyor(name: "c0", index: 0, x1: 1_000, x2: 3_000, y: 1)
        let c2 = Conveyor(name: "c2", index: 1, x1: 2_000, x2: 8_000, y: 3)
        let c3 = Conveyor(name: "c3", index: 2, x1: 5_000, x2: 9_000, y: 6)
        let c5 = Conveyor(name: "c5", index: 3, x1: 8_000, x2: 12_000, y: 9)
        return TestCase(conveyors: [c0, c2, c3, c5])
    }
    
    static var test_case_stairs_with_double: TestCase {
        
        // y = 9, good
        // x1 = 1000, good
        // x2 = 3000, good
        let c0 = Conveyor(name: "c0", index: 0, x1: 1_000, x2: 3_000, y: 9)
        
        // y = 10, good
        // x1 = 8000, good
        // x2 = 12000, good
        let c1 = Conveyor(name: "c1", index: 0, x1: 8_000, x2: 12_000, y: 10)
        
        // y = 8, good
        // x1 = 2000, good
        // x2 = 8000, good
        let c2 = Conveyor(name: "c2", index: 1, x1: 2_000, x2: 8_000, y: 8)
        
        // y = 7, good
        // x1 = 5000, good
        // x2 = 9000, good
        let c3 = Conveyor(name: "c3", index: 2, x1: 5_000, x2: 9_000, y: 7)
        
        // y = 6, good
        // x1 = 8000, good
        // x2 = 12000, good
        let c5 = Conveyor(name: "c5", index: 3, x1: 8_000, x2: 12_000, y: 6)

        return TestCase(conveyors: [c0, c1, c2, c3, c5])
    }
    
    static var test_case_1: TestCase {
        let c0 = Conveyor(name: "c0", index: 0, x1: 100_000, x2: 600_000, y: 10)
        let c1 = Conveyor(name: "c1", index: 1, x1: 400_000, x2: 800_000, y: 20)
        return TestCase(conveyors: [c0, c1])
    }
    
    static var test_case_2: TestCase {
        
        let c0 = Conveyor(name: "1st", index: 0, x1: 5_000, x2: 7_000, y: 2)
        let c1 = Conveyor(name: "2nd", index: 1, x1: 2_000, x2: 8_000, y: 8)
        let c2 = Conveyor(name: "3rd", index: 2, x1: 7_000, x2: 11_000, y: 5)
        let c3 = Conveyor(name: "4th", index: 3, x1: 9_000, x2: 11_000, y: 9)
        let c4 = Conveyor(name: "5th", index: 4, x1: 0, x2: 4_000, y: 4)
        
        return TestCase(conveyors: [c0, c1, c2, c3, c4])
        
        /*
        let c1 = Conveyor(name: "c1", index: 1, x1: 2_000, x2: 8_000, y: 8)
        return TestCase(conveyors: [c1])
        */
        
        // Locked Conveyor:
        
        
        // Conveyor from [0, 4000]
        //{c0, [5000 to 7000, y=2]}
        //{c1, [2000 to 8000, y=8]}
        //{c2, [7000 to 11000, y=5]} (LOCKED)
        //{c3, [9000 to 11000, y=9]}
        //{c4, [0 to 4000, y=4]}
        
        
        //A-Drop: DropConveyor{ (0, 2000] | c4 }
        //Count: 2000, Percent = 0.002
        //C:Left: 1000.0
        //Count: 2000, Percent = 0.002
        //C:Right: 3000.0
        // (Left + Right) / 2 = 2000.0
        //TIMES_PERCENT = 4.0
        
        //A-Drop: DropConveyor{ (2000, 8000) | c1 }
        //Count: 6000, Percent = 0.006
        //C:Left: 3000.0
        //C:Right: 3000.0
        // (Left + Right) / 2 = 3000.0
        // WITH EXTRAS APPLIED:
        //C:Left: 3000.0 + 2000.0 = 5000.0
        //C:Right: 3000.0 + 1000.0 = 4000.0
        // (Left + Right) / 2 = 4500.0
        //TIMES_PERCENT = 27.0
        
        //A-Drop: DropConveyor{ [8000, 9000] | c2 } (LOCKED)
        //Count: 1000, Percent = 0.001
        //C:Left: 1500.0
        //LEFT: 0
        //RIGHT: 0
        //Total: 1500
        //TIMES_PERCENT = 1.5
        
        //A-Drop: DropConveyor{ (9000, 11000) | c3 }
        //Count: 2000, Percent = 0.002
        //C:Left: 1000.0
        //C:Right: 1000.0
        // WITH EXTRAS APPLIED:
        //C:Left: 1000.0 + 2000.0 = 3000.0
        //C:Right: 1000.0
        // (Left + Right) / 2 = 2000.0
        //TIMES_PERCENT = 4.0
        
        //4.0 + 27.0 + 1.5 + 4.0 = 36.5
        
        
        
    }
    
    
}
