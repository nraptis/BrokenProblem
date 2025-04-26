//
//  ColliderTests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/26/25.
//

import Foundation

class ColliderTests {
    
    static func findColliders_BruteForce(conveyors: [Conveyor]) {
        
        func collide(x: Int, y: Int, conveyors: [Conveyor]) -> Conveyor? {
            var result: Conveyor?
            for conveyor in conveyors {
                if x > conveyor.x1 && x < conveyor.x2 {
                    if y > conveyor.y {
                        if let best = result {
                            if conveyor.y > best.y {
                                result = conveyor
                            }
                        } else {
                            result = conveyor
                        }
                    }
                }
            }
            return result
        }
        
        for conveyor in conveyors {
            conveyor.left_collider = collide(x: conveyor.x1, y: conveyor.y, conveyors: conveyors)
            conveyor.right_collider = collide(x: conveyor.x2, y: conveyor.y, conveyors: conveyors)
        }
    }
    
    static func execute(name: String, conveyors: [Conveyor]) -> Bool {
        
        let conveyors1 = Conveyor.clone(conveyors: conveyors)
        let conveyors2 = Conveyor.clone(conveyors: conveyors)
        
        findCollidersAndParents(conveyors: conveyors1)
        findColliders_BruteForce(conveyors: conveyors2)
        
        for index in conveyors1.indices {
            let conveyor1 = conveyors1[index]
            let conveyor2 = conveyors2[index]
            
            if conveyor1.index != conveyor2.index {
                print("Test Failed! \(name) Conveyor 1 is \(conveyor1.index), Conveyor 2 is \(conveyor2.index) at \(index)")
                return false
            }
            
            var lc_left_1 = -1
            var lc_left_2 = -1
            if let left_collider = conveyor1.left_collider {
                lc_left_1 = left_collider.index
            }
            if let left_collider = conveyor2.left_collider {
                lc_left_2 = left_collider.index
            }
            
            if lc_left_1 != lc_left_2 {
                print("Test Failed! \(name) Conveyor 1 is \(conveyor1.index), Conveyor 2 is \(conveyor2.index) at \(index)")
                print("Test Failed! \(name) Conveyor 1 Left is \(lc_left_1), Conveyor 2 Left is \(lc_left_2) at \(index)")
                return false
            }
            
            var rc_right_1 = -1
            var rc_right_2 = -1
            if let right_collider = conveyor1.right_collider {
                rc_right_1 = right_collider.index
            }
            if let right_collider = conveyor2.right_collider {
                rc_right_2 = right_collider.index
            }
            
            if rc_right_1 != rc_right_2 {
                print("Test Failed! \(name) Conveyor 1 is \(conveyor1.index), Conveyor 2 is \(conveyor2.index) at \(index)")
                print("Test Failed! \(name) Conveyor 1 Right is \(rc_right_1), Conveyor 2 Right is \(rc_right_2) at \(index)")
                return false
            }
            
        }
        return true
    }
    
    static func test_all() {
        test_simple_overlap_right()
        test_simple_overlap_right()
        test_simple_overlap_both()
        test_simple_kiss_left()
        test_simple_kiss_right()
        test_touching_ends_a()
        
        test_1000_2_conveyor()
        test_1000_3_conveyor()
        test_1000_4_conveyor()
        test_1000_5_conveyor()
        test_1000_6_conveyor()
        test_100000_medium_harsh()
    }
    
    static func test_simple_overlap_right() {
        
        //
        //              [        c0        ]
        //                  [        c1        ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(name: "c0", index: 0, x1: 300000, x2: 800000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 400000, x2: 900000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_simple_overlap_right", conveyors: conveyors)
    }
    
    static func test_simple_overlap_left() {
        
        //
        //                  [        c0        ]
        //              [        c1        ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(name: "c0", index: 0, x1: 400000, x2: 900000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 300000, x2: 800000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_simple_overlap_left", conveyors: conveyors)
    }
    
    static func test_simple_overlap_both() {
        
        //
        //                  [        c0        ]
        //              [            c1            ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(name: "c0", index: 0, x1: 400000, x2: 900000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 300000, x2: 1000000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_simple_overlap_both", conveyors: conveyors)
    }
    
    static func test_simple_kiss_left() {
        
        //
        //                  [        c0        ]
        //      [    c1     ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(name: "c0", index: 0, x1: 400_000, x2: 900_000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 100_000, x2: 400_000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_simple_kiss_left", conveyors: conveyors)
    }
    
    static func test_simple_kiss_right() {
        
        //
        //      [       c0         ]
        //                         [       c1      ]
        
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(name: "c0", index: 0, x1: 100_000, x2: 600_000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 600_000, x2: 1_000_000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_simple_kiss_right", conveyors: conveyors)
    }
    
    static func test_touching_ends_a() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 100_000, x2: 200_000, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 200_000, x2: 300_000, y: 0)
        let conveyors = [c0, c1]
        _ = execute(name: "test_touching_ends_a", conveyors: conveyors)
    }
    
    static func test_1000_2_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 2, max_count: 2)
            if execute(name: "test_1000_two_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_two_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_3_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 3, max_count: 3)
            if execute(name: "test_1000_3_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_3_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_4_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 4, max_count: 4)
            if execute(name: "test_1000_4_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_4_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_5_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 5, max_count: 5)
            if execute(name: "test_1000_5_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_5_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_6_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 6, max_count: 6)
            if execute(name: "test_1000_6_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_6_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_100000_medium_harsh() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<100000 {
            
            let conveyors = GENERATE_HARSH(min_count: 1, max_count: 8)
            if execute(name: "test_100000_medium_harsh\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_100000_medium_harsh => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func GENERATE(min_count: Int, max_count: Int, tries: Int = 256) -> [Conveyor] {
        let count = Int.random(in: min(max_count, min_count)...max(max_count, min_count))
        let xs = [0, 100_000, 200_000, 300_000, 400_000, 500_000, 600_000, 700_000, 800_000, 900_000, 1_000_000]
        let ys = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        var result = [Conveyor]()
        var tryIndex = 0
        var conveyorIndex = 0
        while result.count < count && tryIndex < tries {
            let x1 = xs.randomElement()!
            let x2 = xs.randomElement()!
            let y = ys.randomElement()!
            if x2 > x1 {
                var overlaps = false
                for conveyor in result {
                    if conveyor.y == y {
                        if x1 >= conveyor.x1 && x1 <= conveyor.x2 {
                            overlaps = true
                            break
                        }
                        if x2 >= conveyor.x1 && x2 <= conveyor.x2 {
                            overlaps = true
                            break
                        }
                        if conveyor.x1 >= x1 && conveyor.x1 <= x2 {
                            overlaps = true
                            break
                        }
                        if conveyor.x2 >= x1 && conveyor.x2 <= x2 {
                            overlaps = true
                            break
                        }
                        
                    }
                }
                
                if overlaps == false {
                    let c = Conveyor(name: "c_\(conveyorIndex)", index: conveyorIndex, x1: x1, x2: x2, y: y)
                    result.append(c)
                    conveyorIndex += 1
                }
            }
            tryIndex += 1
        }
        
        return result
    }
    
    static func GENERATE_HARSH(min_count: Int, max_count: Int, tries: Int = 256) -> [Conveyor] {
        
        let count = Int.random(in: min(max_count, min_count)...max(max_count, min_count))
        
        var result = [Conveyor]()
        var tryIndex = 0
        var conveyorIndex = 0
        while result.count < count && tryIndex < tries {
            
            let x1 = Int.random(in: 0...1_000_000)
            let x2 = Int.random(in: 0...1_000_000)
            let y = Int.random(in: 0...900_000)
            if x2 > x1 {
                var overlaps = false
                for conveyor in result {
                    if conveyor.y == y {
                        if x1 >= conveyor.x1 && x1 <= conveyor.x2 {
                            overlaps = true
                            break
                        }
                        if x2 >= conveyor.x1 && x2 <= conveyor.x2 {
                            overlaps = true
                            break
                        }
                        if conveyor.x1 >= x1 && conveyor.x1 <= x2 {
                            overlaps = true
                            break
                        }
                        if conveyor.x2 >= x1 && conveyor.x2 <= x2 {
                            overlaps = true
                            break
                        }
                        
                    }
                }
                
                if overlaps == false {
                    let c = Conveyor(name: "c_\(conveyorIndex)", index: conveyorIndex, x1: x1, x2: x2, y: y)
                    result.append(c)
                    conveyorIndex += 1
                }
                
                
            }
            
            tryIndex += 1
        }
        
        return result
    }
}
