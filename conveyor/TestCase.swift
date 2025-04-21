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
    
    static var test_case_2: TestCase {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 5_000, x2: 7_000, y: 2)
        let c1 = Conveyor(name: "c1", index: 1, x1: 2_000, x2: 8_000, y: 8)
        let c2 = Conveyor(name: "c2", index: 2, x1: 7_000, x2: 11_000, y: 5)
        let c3 = Conveyor(name: "c3", index: 3, x1: 9_000, x2: 11_000, y: 9)
        let c4 = Conveyor(name: "c4", index: 4, x1: 0, x2: 4_000, y: 4)
        
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
