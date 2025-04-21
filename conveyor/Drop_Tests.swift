//
//  DropTests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

struct Drop_Tests {
    
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
    
    static func print_one(name: String, drops_expected: [Drop]) {
        
        print("[Passed] =======>")
        print("[Passed] {\(name)}: Expected Drops")
        for index in drops_expected.indices {
            let drop = drops_expected[index]
            print("[Passed] @ \(index), Drop = \(drop)")
        }
        
    }
    
    static func print_both(name: String, drops_expected: [Drop], drops_actual: [Drop]) {
        
        print("[FAILED] =======>")
        print("[FAILED] {\(name)}: Expected Drops")
        for index in drops_expected.indices {
            let drop = drops_expected[index]
            print("[FAILED] @ \(index), Drop = \(drop)")
        }
        
        print("[FAILED] =======>")
        print("[FAILED] {\(name)}: Actual Drops")
        for index in drops_actual.indices {
            let drop = drops_actual[index]
            print("[FAILED] @ \(index), Drop = \(drop)")
        }
        
        print("___________________________")
    }
    
    static func validate(name: String, drops_expected: [Drop], drops_actual: [Drop], conveyors: [Conveyor]) {
        
        
        
        if drops_expected.count != drops_actual.count {
            for conveyor in conveyors {
                print("[C] ==> \(conveyor)")
            }
            print("Validate Failed For {\(name)}, count mistmatch!")
            print_both(name: name, drops_expected: drops_expected, drops_actual: drops_actual)
            return
        }
        
        var allEqual = true
        var failIndex = 0
        for index in 0..<drops_expected.count {
            if drops_expected[index] != drops_actual[index] {
                failIndex = index
                allEqual = false
                break
            }
        }
        if allEqual == false {
            for conveyor in conveyors {
                print("[C] ==> \(conveyor)")
            }
            print("Validate Failed For {\(name)}, at index: \(failIndex)!")
            print_both(name: name, drops_expected: drops_expected, drops_actual: drops_actual)
            return
        }
        
        /*
        print("Test passed for {\(name)}!!!")
        print_one(name: name, drops_expected: drops_expected)
        */
        
    }
    
    static func test_no_conveyors() {
        let conveyors = [Conveyor]()
        let expected = [Drop.empty(.interval(Interval(start: .closed(0), end: .closed(1_000_000))))]
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_no_conveyors",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_no_conveyors",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_example_one() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 100_000, x2: 600_000, y: 10)
        let c1 = Conveyor(name: "c1", index: 1, x1: 400_000, x2: 800_000, y: 20)
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(100_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c1.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_example_one",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_example_one",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
        
    }
    
    static func test_simple_gap() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 30, x2: 50, y: 200)
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(10)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.open(c0.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c0.x2)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c1.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_simple_gap",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_simple_gap",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
        
    }
    
    static func test_failed_test_a() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 39, x2: 81, y: 89)
        let c1 = Conveyor(name: "c1", index: 1, x1: 50, x2: 95, y: 82)
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(c0.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.open(c0.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c0.x2)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c1.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_failed_test_a",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_failed_test_a",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_failed_test_b() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 79, x2: 81, y: 45)
        let c1 = Conveyor(name: "c1", index: 1, x1: 71, x2: 72, y: 28)
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(c0.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.open(c0.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c0.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_failed_test_b",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_failed_test_b",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_failed_test_c() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 92, x2: 95, y: 65)
        let c1 = Conveyor(name: "c1", index: 1, x1: 46, x2: 93, y: 21)
        
        //[0, 46]
        //(46, 92]
        //(92, 95)
        //[95, 1_000_000]
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(46)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(46)
            let end = Boundary.closed(92)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            
            let start = Boundary.open(92)
            let end = Boundary.open(95)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(95)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_failed_test_c",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_failed_test_c",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_failed_test_d() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 43, x2: 57, y: 4)
        let c1 = Conveyor(name: "c1", index: 1, x1: 26, x2: 43, y: 38)
        
        //[0, 26]
        //(26, 43)
        //[43]
        //(43, 57)
        //[57, 1_000_000]
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(26)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(26)
            let end = Boundary.open(43)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            
            let span = Span.point(43)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(43)
            let end = Boundary.open(57)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(57)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_failed_test_d",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_failed_test_d",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_failed_test_e() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 51, x2: 78, y: 27)
        let c1 = Conveyor(name: "c1", index: 1, x1: 24, x2: 52, y: 72)
        
        //[0, 24]
        //(24, 52)
        //[52, 78)
        //[78, 1_000_000]
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(24)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(24)
            let end = Boundary.open(52)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(52)
            let end = Boundary.open(78)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(78)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_failed_test_e",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_failed_test_e",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_failed_test_f() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 29, x2: 63, y: 68)
        let c1 = Conveyor(name: "c1", index: 1, x1: 9, x2: 29, y: 46)
        let c2 = Conveyor(name: "c2", index: 2, x1: 7, x2: 94, y: 36)
        
        
        //[0, 7]
        //(7, 9]
        //(9, 29)
        //[29]
        //(29, 63)
        //[63, 94)
        //[94, 1_000_000]
        
        let conveyors = [c0, c1, c2]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(7)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(7)
            let end = Boundary.closed(9)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(9)
            let end = Boundary.open(29)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let span = Span.point(29)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(29)
            let end = Boundary.open(63)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(63)
            let end = Boundary.open(94)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(94)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_failed_test_f",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_failed_test_f",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_one_gap() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 25, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 26, x2: 50, y: 200)
        
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(10)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.open(c0.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c0.x2)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c1.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_one_gap",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_one_gap",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_one_conveyor_small() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 0, x2: 1, y: 10)
        let conveyors = [c0]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_one_conveyor_small_zero",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_one_conveyor_small_zero",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    
    
    static func test_one_conveyor_ten() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 10)
        let conveyors = [c0]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(10)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.open(c0.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(20)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_one_conveyor_small",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_one_conveyor_small",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_simple_overlap() {
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let conveyors = [c0, c1]
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(c0.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        if true {
            // This is along c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        if true {
            // This is along c1
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        if true {
            // This is the end
            let start = Boundary.closed(c1.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_simple_overlap",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_simple_overlap",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    static func test_simple_overlap_under_mono() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 10, x2: 30, y: 50)
        
        let conveyors = [c0, c1, c2]
        
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(c0.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        if true {
            // This is along c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        if true {
            // This is along c1
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        if true {
            // This is the end
            let start = Boundary.closed(c1.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_simple_overlap_under_mono",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_simple_overlap_under_mono",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    
    
    static func test_mixed_overlap_under_mono() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 5, x2: 35, y: 50)
        
        let conveyors = [c0, c1, c2]
        
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(c2.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c2.x1)
            let end = Boundary.closed(c0.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        
        if true {
            // This is along c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        if true {
            // This is along c1
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c1.x2)
            let end = Boundary.open(c2.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        if true {
            // This is the end
            let start = Boundary.closed(c2.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_mixed_overlap_under_mono",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_mixed_overlap_under_mono",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
    }
    
    
    
    static func test_mixed_overlap_under_mono_with_flare() {
        
        let c0 = Conveyor(name: "c0", index: 0, x1: 10, x2: 20, y: 100)
        let c1 = Conveyor(name: "c1", index: 1, x1: 15, x2: 30, y: 200)
        let c2 = Conveyor(name: "c2", index: 2, x1: 5, x2: 35, y: 50)
        
        //             [    c1     ]
        //         [   c0  ]
        //     [             c2         ]
        //
        // 00  05  10  15  20  25  30  35  40
        
        let ca = Conveyor(name: "ca", index: 3, x1: 20, x2: 25, y: 40)
        let cb = Conveyor(name: "cb", index: 4, x1: 10, x2: 20, y: 30)
        let cc = Conveyor(name: "cc", index: 5, x1: 10, x2: 30, y: 20)
        let cd = Conveyor(name: "cd", index: 6, x1: 20, x2: 25, y: 25)
        let ce = Conveyor(name: "ce", index: 7, x1: 10, x2: 15, y: 10)
        let cf = Conveyor(name: "cf", index: 8, x1: 15, x2: 20, y: 5)
        
        
        
        let conveyors = [c0, c1, c2,
                         ca, cb, cc, cd, ce, cf]
        
        var expected = [Drop]()
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(0)
            let end = Boundary.closed(c2.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        if true {
            // This is from 0 to c0
            let start = Boundary.open(c2.x1)
            let end = Boundary.closed(c0.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        
        if true {
            // This is along c0
            let start = Boundary.open(c0.x1)
            let end = Boundary.closed(c1.x1)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c0)
            expected.append(drop)
        }
        if true {
            // This is along c1
            let start = Boundary.open(c1.x1)
            let end = Boundary.open(c1.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c1)
            expected.append(drop)
        }
        if true {
            // This is from 0 to c0
            let start = Boundary.closed(c1.x2)
            let end = Boundary.open(c2.x2)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, c2)
            expected.append(drop)
        }
        if true {
            // This is the end
            let start = Boundary.closed(c2.x2)
            let end = Boundary.closed(1_000_000)
            let interval = Interval(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.empty(span)
            expected.append(drop)
        }
        
        let actual = getDrops(conveyors: conveyors)
        validate(name: "test_mixed_overlap_under_mono_with_flare",
                 drops_expected: expected,
                 drops_actual: actual,
                 conveyors: conveyors)
        
        let brute = getDrops_brute_force(conveyors: conveyors)
        validate(name: "BRUTE_test_mixed_overlap_under_mono_with_flare",
                 drops_expected: expected,
                 drops_actual: brute,
                 conveyors: conveyors)
        
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
            let drops_actual = getDrops(conveyors: conveyors)
            let drops_expected = getDrops_brute_force(conveyors: conveyors)
            validate(name: "test_10000_one_conveyor",
                     drops_expected: drops_expected, drops_actual: drops_actual, conveyors: conveyors)
            
            
        }
        print("test_10000_one_conveyor => Done!")
        
        
    }
    
    static func test_10000_two_conveyor() {
        
        for _ in 0..<10000 {
            
            let conveyors = GENERATE(min_count: 2, max_count: 2)
            let drops_actual = getDrops(conveyors: conveyors)
            let drops_expected = getDrops_brute_force(conveyors: conveyors)
            validate(name: "test_10000_two_conveyor",
                     drops_expected: drops_expected, drops_actual: drops_actual, conveyors: conveyors)
            
            
        }
        print("test_10000_two_conveyor => Done!")
        
        
    }
    
    static func test_10000_three_conveyor() {
        
        for _ in 0..<10000 {
            
            let conveyors = GENERATE(min_count: 3, max_count: 3)
            let drops_actual = getDrops(conveyors: conveyors)
            let drops_expected = getDrops_brute_force(conveyors: conveyors)
            validate(name: "test_10000_three_conveyor",
                     drops_expected: drops_expected, drops_actual: drops_actual, conveyors: conveyors)
            
            
        }
        print("test_10000_three_conveyor => Done!")
    }
    
    static func test_10000_twenty_conveyor() {
        for _ in 0..<10000 {
            let conveyors = GENERATE(min_count: 1, max_count: 20)
            let drops_actual = getDrops(conveyors: conveyors)
            let drops_expected = getDrops_brute_force(conveyors: conveyors)
            validate(name: "test_10000_twenty_conveyor",
                     drops_expected: drops_expected, drops_actual: drops_actual, conveyors: conveyors)
        }
        print("test_10000_three_conveyor => Done!")
    }
    
    static func test_10000_to_max() {
        for _ in 0..<10000 {
            let conveyors = GENERATE(min_count: 1, max_count: 25, min_x: 1_000_000-100, max_x: 1_000_000)
            let drops_actual = getDrops(conveyors: conveyors)
            let drops_expected = getDrops_brute_force(conveyors: conveyors)
            validate(name: "test_10000_to_max",
                     drops_expected: drops_expected, drops_actual: drops_actual, conveyors: conveyors)
        }
        print("test_10000_to_max => Done!")
    }
    
    static func test_100000_whole_lotta_love() {
        for _ in 0..<100000 {
            let conveyors = GENERATE(min_count: 0, max_count: 40, min_x: 0, max_x: 1_000_000)
            let drops_actual = getDrops(conveyors: conveyors)
            let drops_expected = getDrops_brute_force(conveyors: conveyors)
            validate(name: "test_100000_whole_lotta_love",
                     drops_expected: drops_expected, drops_actual: drops_actual, conveyors: conveyors)
        }
        print("test_100000_whole_lotta_love => Done!")
    }
    
}
