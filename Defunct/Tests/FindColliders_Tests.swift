//
//  FindColliders_Tests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

class FindColliders_Tests {
    
    static func clone(conveyors: [Conveyor]) -> [Conveyor] {
        var result: [Conveyor] = []
        for conveyor in conveyors {
            result.append(Conveyor(name: conveyor.name,
                                   index: conveyor.index,
                                   x1: conveyor.x1,
                                   x2: conveyor.x2,
                                   y: conveyor.y))
        }
        return result
    }
    
    static func compare_colliders(conveyor1: Conveyor, conveyor2: Conveyor) -> Bool {
        if conveyor1 != conveyor2 { return false }
        if conveyor1.left_collider != conveyor2.left_collider { return false }
        if conveyor1.right_collider != conveyor2.right_collider { return false }
        return true
    }
    
    static func test_all() {
        test_no_conveyors()
        test_example_one()
        test_one_conveyor_small()
        test_one_conveyor_ten()
        test_simple_gap()
        test_simple_overlap()
        test_simple_overlap_under_mono()
        test_mixed_overlap_under_mono()
        test_mixed_overlap_under_mono_with_flare()
        test_failed_test_a()
        test_failed_test_b()
        test_failed_test_c()
        test_failed_test_d()
        test_failed_test_e()
        test_failed_test_g()
        test_failed_test_h()
        
        for _ in 0..<10 {
            test_10000_two_conveyor()
            test_10000_three_conveyor()
            test_10000_twenty_conveyor()
            test_10000_to_max()
        }
        
        for _ in 0..<5 {
            test_100000_whole_lotta_love()
        }
    }
    
    static func print_conveyor(conveyor: Conveyor) -> String {
        
        let left_string: String
        if let left_collider = conveyor.left_collider {
            left_string = "\(left_collider.name)"
        } else {
            left_string = "NULL"
        }
        let right_string: String
                if let right_collider = conveyor.right_collider {
                    right_string = "\(right_collider.name)"
                } else {
                    right_string = "NULL"
                }
        return "Conveyor{name: \(conveyor.name) x: [\(conveyor.x1) to \(conveyor.x2)] y: \(conveyor.y) left: \(left_string) right: \(right_string)}"
    }
    
    static func print_one(name: String, conveyors: [Conveyor]) {
        
        print("[Passed] =======>")
        print("[Passed] {\(name)}: Correct Conveyors")
        for index in conveyors.indices {
            let conveyor = conveyors[index]
            let text = print_conveyor(conveyor: conveyor)
            print("[Passed] @ \(index) ==> \(text)")
        }
        
    }
    
    static func print_both(name: String, conveyors_expected: [Conveyor], conveyors_actual: [Conveyor]) {
        
        print("[FAILED] =======>")
        print("[FAILED] {\(name)}: Expected Conveyors")
        for index in conveyors_expected.indices {
            let conveyor = conveyors_expected[index]
            let text = print_conveyor(conveyor: conveyor)
            print("[FAILED] @ \(index) ==> \(text)")
        }
        
        print("[FAILED] =======>")
        print("[FAILED] {\(name)}: Actual Conveyors")
        for index in conveyors_actual.indices {
            let conveyor = conveyors_actual[index]
            let text = print_conveyor(conveyor: conveyor)
            print("[FAILED] @ \(index) ==> \(text)")
        }
        
        print("___________________________")
    }
    
    static func validate(name: String, conveyors_expected: [Conveyor], conveyors_actual: [Conveyor]) {
        
        
        
        if conveyors_expected.count != conveyors_actual.count {
            
            print("Validate Failed For {\(name)}, count mistmatch!")
            print_both(name: name, conveyors_expected: conveyors_expected, conveyors_actual: conveyors_actual)
            return
        }
        
        var allEqual = true
        var failIndex = 0
        for index in 0..<conveyors_expected.count {
            
            let c1 = conveyors_expected[index]
            let c2 = conveyors_actual[index]
            
            if !compare_colliders(conveyor1: c1, conveyor2: c2) {
                failIndex = index
                allEqual = false
                break
            }
        }
        if allEqual == false {
            print("Validate Failed For {\(name)}, at index: \(failIndex)!")
            print_both(name: name, conveyors_expected: conveyors_expected, conveyors_actual: conveyors_actual)
            return
        }
        
        /*
        print("Passed! \(name)")
        print_one(name: name, conveyors: conveyors_expected)
        */
    }
    
    static func test_no_conveyors() {
        let conveyors = [Conveyor]()
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_no_conveyors", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_example_one() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 100_000, x2: 600_000, y: 10)
        let c1 = Conveyor(name: "c1", index: 1, x1: 400_000, x2: 800_000, y: 20)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_example_one", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_simple_gap() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 30, x2: 50, y: 200)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_simple_gap", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_a() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 39, x2: 81, y: 89)
        let c1 = Conveyor(name: "c1", index: 1, x1: 50, x2: 95, y: 82)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_a", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_b() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 79, x2: 81, y: 45)
        let c1 = Conveyor(name: "c1", index: 1, x1: 71, x2: 72, y: 28)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_b", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_c() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 92, x2: 95, y: 65)
        let c1 = Conveyor(name: "c1", index: 1, x1: 46, x2: 93, y: 21)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_c", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_d() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 43, x2: 57, y: 4)
        let c1 = Conveyor(name: "c1", index: 1, x1: 26, x2: 43, y: 38)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_d", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_e() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 51, x2: 78, y: 27)
        let c1 = Conveyor(name: "c1", index: 1, x1: 24, x2: 52, y: 72)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_e", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_f() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 29, x2: 63, y: 68)
        let c1 = Conveyor(name: "c1", index: 1, x1: 9, x2: 29, y: 46)
        let c2 = Conveyor(name: "c2", index: 2, x1: 7, x2: 94, y: 36)
        let conveyors = [c0, c1, c2]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_f", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_g() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 48, x2: 64, y: 44)
        let c1 = Conveyor(name: "c1", index: 1, x1: 48, x2: 63, y: 90)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_g", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_failed_test_h() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 14, x2: 93, y: 85)
        let c1 = Conveyor(name: "c1", index: 1, x1: 63, x2: 89, y: 39)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_failed_test_h", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    
    static func test_one_gap() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 25, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 26, x2: 50, y: 200)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_one_gap", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_one_conveyor_small() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 0, x2: 1, y: 10)
        let conveyors = [c0]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_one_conveyor_small", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_one_conveyor_ten() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 10)
        let conveyors = [c0]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_one_conveyor_ten", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_simple_overlap() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let conveyors = [c0, c1]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_simple_overlap", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_simple_overlap_under_mono() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 10, x2: 30, y: 50)
        let conveyors = [c0, c1, c2]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_simple_overlap_under_mono", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_mixed_overlap_under_mono() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 5, x2: 35, y: 50)
        
        let conveyors = [c0, c1, c2]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_mixed_overlap_under_mono", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func test_mixed_overlap_under_mono_with_flare() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 5, x2: 35, y: 50)
        let ca = Conveyor(name: "ca", index: 3, x1: 20, x2: 25, y: 40)
        let cb = Conveyor(name: "cb", index: 4, x1: 10, x2: 20, y: 30)
        let cc = Conveyor(name: "cc", index: 5, x1: 10, x2: 30, y: 20)
        let cd = Conveyor(name: "cd", index: 6, x1: 20, x2: 25, y: 25)
        let ce = Conveyor(name: "ce", index: 7, x1: 10, x2: 15, y: 10)
        let cf = Conveyor(name: "cf", index: 8, x1: 15, x2: 20, y: 5)
        let conveyors = [c0, c1, c2,
                         ca, cb, cc, cd, ce, cf]
        let conveyors_1 = clone(conveyors: conveyors)
        let conveyors_2 = clone(conveyors: conveyors)
        findColliders(conveyors: conveyors_1)
        findColliders_BruteForce(conveyors: conveyors_2)
        validate(name: "test_mixed_overlap_under_mono_with_flare", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
    }
    
    static func GENERATE(min_count: Int, max_count: Int, tries: Int = 256, min_y: Int = 1, max_y: Int = 100, min_x: Int = 0, max_x: Int = 100) -> [Conveyor] {
        
        let count = Int.random(in: min(max_count, min_count)...max(max_count, min_count))
        
        var result = [Conveyor]()
        var tryIndex = 0
        var conveyorIndex = 0
        while result.count < count && tryIndex < tries {
            
            let x1 = Int.random(in: min_x...max_x)
            let x2 = Int.random(in: x1...max_x)
            let y = Int.random(in: min_y...max_y)
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
    
    static func test_10000_one_conveyor() {
        
        for _ in 0..<10000 {
            
            let conveyors = GENERATE(min_count: 1, max_count: 1)
            let conveyors_1 = clone(conveyors: conveyors)
            let conveyors_2 = clone(conveyors: conveyors)
            findColliders(conveyors: conveyors_1)
            findColliders_BruteForce(conveyors: conveyors_2)
            validate(name: "test_10000_one_conveyor", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
        }
        print("test_10000_one_conveyor => Done!")
    }
    
    static func test_10000_two_conveyor() {
        for _ in 0..<10000 {
            let conveyors = GENERATE(min_count: 2, max_count: 2)
            let conveyors_1 = clone(conveyors: conveyors)
            let conveyors_2 = clone(conveyors: conveyors)
            findColliders(conveyors: conveyors_1)
            findColliders_BruteForce(conveyors: conveyors_2)
            validate(name: "test_10000_two_conveyor", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
        }
        print("test_10000_two_conveyor => Done!")
    }
    
    static func test_10000_three_conveyor() {
        
        for _ in 0..<10000 {
            
            let conveyors = GENERATE(min_count: 3, max_count: 3)
            let conveyors_1 = clone(conveyors: conveyors)
            let conveyors_2 = clone(conveyors: conveyors)
            findColliders(conveyors: conveyors_1)
            findColliders_BruteForce(conveyors: conveyors_2)
            validate(name: "test_10000_three_conveyor", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
        }
        print("test_10000_three_conveyor => Done!")
    }
    
    static func test_10000_twenty_conveyor() {
        for _ in 0..<10000 {
            let conveyors = GENERATE(min_count: 1, max_count: 20)
            let conveyors_1 = clone(conveyors: conveyors)
            let conveyors_2 = clone(conveyors: conveyors)
            findColliders(conveyors: conveyors_1)
            findColliders_BruteForce(conveyors: conveyors_2)
            validate(name: "test_10000_twenty_conveyor", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
        }
        print("test_10000_twenty_conveyor => Done!")
    }
    
    static func test_10000_to_max() {
        for _ in 0..<10000 {
            let conveyors = GENERATE(min_count: 1, max_count: 25, min_x: 1_000_000-100, max_x: 1_000_000)
            let conveyors_1 = clone(conveyors: conveyors)
            let conveyors_2 = clone(conveyors: conveyors)
            findColliders(conveyors: conveyors_1)
            findColliders_BruteForce(conveyors: conveyors_2)
            validate(name: "test_10000_to_max", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
        }
        print("test_10000_to_max => Done!")
    }
    
    static func test_100000_whole_lotta_love() {
        for _ in 0..<100000 {
            let conveyors = GENERATE(min_count: 0, max_count: 40, min_x: 0, max_x: 1_000_000)
            let conveyors_1 = clone(conveyors: conveyors)
            let conveyors_2 = clone(conveyors: conveyors)
            findColliders(conveyors: conveyors_1)
            findColliders_BruteForce(conveyors: conveyors_2)
            validate(name: "test_100000_whole_lotta_love", conveyors_expected: conveyors_2, conveyors_actual: conveyors_1)
        }
        print("test_100000_whole_lotta_love => Done!")
    }
    
}
