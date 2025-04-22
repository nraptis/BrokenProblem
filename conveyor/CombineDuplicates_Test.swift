//
//  CombineDuplicates_Test.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

class CombineDuplicates_Test {
    
    static func test_all() {
        test_simple_case_with_2()
        test_simple_case_with_3()
        test_simple_case_with_4()
        test_simple_case_with_5()
        test_simple_case_with_6()
        test_simple_case_with_7()
        test_simple_case_with_8()
        test_simple_case_with_9()
        test_simple_case_with_10()
        
        test_failed_case_a()
        test_failed_case_b()
        
        for _ in 0..<10 {
            test_10_tiny_random_trials()
        }
        for _ in 0..<10 {
            test_100_small_random_trials()
        }
        
        for _ in 0..<10 {
            test_1000_medium_random_trials()
        }
        
        for _ in 0..<5 {
            test_10000_large_random_trials()
        }
        
    }
    
    private static func combine_duplicates_brute_force(datums: [EdgeInfoDatum]) -> [EdgeInfoDatum] {
        var result = Array(datums)

        while true {
            var combine_datum_1_index = -1
            var combine_datum_2_index = -1

            outer_loop: for index1 in 0..<result.count {
                for index2 in (index1 + 1)..<result.count {
                    if result[index1] == result[index2], result[index1].divided > 1 {
                        combine_datum_1_index = index1
                        combine_datum_2_index = index2
                        break outer_loop
                    }
                }
            }

            if combine_datum_1_index == -1 || combine_datum_2_index == -1 {
                break
            }

            var new_result = [EdgeInfoDatum]()
            for index in result.indices {
                if index != combine_datum_1_index && index != combine_datum_2_index {
                    new_result.append(result[index])
                }
            }

            let old_datum = result[combine_datum_1_index]
            let new_datum = EdgeInfoDatum(distance: old_datum.distance, divided: old_datum.divided / 2)
            new_result.append(new_datum)

            result = new_result
        }

        return result
    }
    
    /*
    private static func combine_duplicates_brute_force(datums: [EdgeInfoDatum]) -> [EdgeInfoDatum] {
        var result = Array(datums)
        
        while true {
            var combine_datum_1_index = -1
            var combine_datum_2_index = -1
            
            var index1 = 0
            while index1 < result.count {
                if combine_datum_1_index != -1 { break }
                var index2 = index1 + 1
                while index2 < result.count {
                    if combine_datum_2_index != -1 { break }
                    if result[index1] == result[index2] {
                        if result[index1].divided > 1 {
                            combine_datum_1_index = index1
                            combine_datum_2_index = index2
                        }
                    }
                    index2 += 1
                }
                index1 += 1
            }
            
            if combine_datum_1_index == -1 { break }
            if combine_datum_2_index == -1 { break }
            
            
            var new_result = [EdgeInfoDatum]()
            for index in result.indices {
                if index == combine_datum_1_index {
                    continue
                }
                if index == combine_datum_2_index {
                    continue
                }
                new_result.append(result[index])
            }
            
            let old_datum = result[combine_datum_1_index]
            let new_divided = old_datum.divided / 2
            let new_distance = old_datum.distance
            let new_datum = EdgeInfoDatum(distance: new_distance, divided: new_divided)
            new_result.append(new_datum)
            
            result = new_result
        }
        
        return result
    }
    */

    static func test_10_tiny_random_trials() {
        
        let divided_possible = [1, 2, 4, 8, 16]
        
        for iteration in 0..<10 {
            
            let datumCount = Int.random(in: 0...12)
            var originalDatums = [EdgeInfoDatum]()
            for _ in 0..<datumCount {
                let datum = EdgeInfoDatum(distance: Int.random(in: 0...4), divided: divided_possible.randomElement()!)
                originalDatums.append(datum)
            }
            let expectedDatums = combine_duplicates_brute_force(datums: originalDatums)
            runTest(name: "test_10_tiny_random_trials_\(iteration)", input: originalDatums, expected: expectedDatums, log_pass: false)
            
        }
        
        print("test_10_tiny_random_trials => Complete!")
    }
    
    static func test_100_small_random_trials() {
        
        let divided_possible = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]
        
        for iteration in 0..<100 {
            
            let datumCount = Int.random(in: 0...24)
            var originalDatums = [EdgeInfoDatum]()
            for _ in 0..<datumCount {
                let datum = EdgeInfoDatum(distance: Int.random(in: 0...12), divided: divided_possible.randomElement()!)
                originalDatums.append(datum)
            }
            let expectedDatums = combine_duplicates_brute_force(datums: originalDatums)
            runTest(name: "test_100_small_random_trials_\(iteration)", input: originalDatums, expected: expectedDatums, log_pass: false)
            
        }
        
        print("test_100_small_random_trials => Complete!")
    }
    
    static func test_1000_medium_random_trials() {
        
        let divided_possible = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]
        
        for iteration in 0..<1000 {
            
            let datumCount = Int.random(in: 0...48)
            var originalDatums = [EdgeInfoDatum]()
            for _ in 0..<datumCount {
                let datum = EdgeInfoDatum(distance: Int.random(in: 0...24), divided: divided_possible.randomElement()!)
                originalDatums.append(datum)
            }
            let expectedDatums = combine_duplicates_brute_force(datums: originalDatums)
            runTest(name: "test_1000_medium_random_trials_\(iteration)", input: originalDatums, expected: expectedDatums, log_pass: false)
            
        }
        
        print("test_1000_medium_random_trials => Complete!")
    }
    
    static func test_10000_large_random_trials() {
        
        let divided_possible = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]
        
        for iteration in 0..<10000 {
            
            let datumCount = Int.random(in: 0...128)
            var originalDatums = [EdgeInfoDatum]()
            for _ in 0..<datumCount {
                let datum = EdgeInfoDatum(distance: Int.random(in: 0...64), divided: divided_possible.randomElement()!)
                originalDatums.append(datum)
            }
            let expectedDatums = combine_duplicates_brute_force(datums: originalDatums)
            runTest(name: "test_1000_medium_random_trials_\(iteration)", input: originalDatums, expected: expectedDatums, log_pass: false)
            
        }
        
        print("test_1000_medium_random_trials => Complete!")
    }
    
    static func test_failed_case_a() {
        let originalDatums = [
            EdgeInfoDatum(distance: 2, divided: 4),
            EdgeInfoDatum(distance: 1, divided: 16),
            EdgeInfoDatum(distance: 1, divided: 16),
            EdgeInfoDatum(distance: 1, divided: 8),
            EdgeInfoDatum(distance: 2, divided: 8),
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 3, divided: 4)
        ]
        
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 1, divided: 4),   // from 16 + 16 → 8, 8 + 8 → 4
            EdgeInfoDatum(distance: 2, divided: 4),
            EdgeInfoDatum(distance: 2, divided: 8),
            EdgeInfoDatum(distance: 3, divided: 4)
        ]
        
        runTest(name: "test_failed_case_a", input: originalDatums, expected: expectedDatums, log_pass: true)
    }
    
    static func test_failed_case_b() {
        let originalDatums = [
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4),
            EdgeInfoDatum(distance: 0, divided: 4)
        ]

        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 4)
        ]

        runTest(name: "test_failed_case_b", input: originalDatums, expected: expectedDatums, log_pass: true)
    }
    
    static func test_simple_case_with_2() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 2)
        let expectedDatums = [EdgeInfoDatum(distance: 0, divided: 2)]
        runTest(name: "test_simple_case_with_2", input: originalDatums, expected: expectedDatums, log_pass: true)
    }
    
    static func test_simple_case_with_3() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 3)
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 2),
            EdgeInfoDatum(distance: 0, divided: 4)
        ]
        runTest(name: "test_simple_case_with_3", input: originalDatums, expected: expectedDatums, log_pass: true)
    }
    
    static func test_simple_case_with_4() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 4)
        let expectedDatums = [EdgeInfoDatum(distance: 0, divided: 1)]
        runTest(name: "test_simple_case_with_4", input: originalDatums, expected: expectedDatums, log_pass: true)
    }
    
    static func test_simple_case_with_5() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 5)
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 4)
        ]
        runTest(name: "test_simple_case_with_5", input: originalDatums, expected: expectedDatums, log_pass: true)
    }

    static func test_simple_case_with_6() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 6)
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 2)
        ]
        runTest(name: "test_simple_case_with_6", input: originalDatums, expected: expectedDatums, log_pass: true)
    }

    static func test_simple_case_with_7() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 7)
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 2),
            EdgeInfoDatum(distance: 0, divided: 4)
        ]
        runTest(name: "test_simple_case_with_7", input: originalDatums, expected: expectedDatums, log_pass: true)
    }

    static func test_simple_case_with_8() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 8)
        let expectedDatums = [EdgeInfoDatum(distance: 0, divided: 1), EdgeInfoDatum(distance: 0, divided: 1)]
        runTest(name: "test_simple_case_with_8", input: originalDatums, expected: expectedDatums, log_pass: true)
    }

    static func test_simple_case_with_9() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 9)
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 4)
        ]
        runTest(name: "test_simple_case_with_9", input: originalDatums, expected: expectedDatums, log_pass: true)
    }

    static func test_simple_case_with_10() {
        let originalDatums = Array(repeating: EdgeInfoDatum(distance: 0, divided: 4), count: 10)
        let expectedDatums = [
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 1),
            EdgeInfoDatum(distance: 0, divided: 2)
        ]
        runTest(name: "test_simple_case_with_10", input: originalDatums, expected: expectedDatums, log_pass: true)
    }
    
    static func runTest(name: String, input: [EdgeInfoDatum], expected: [EdgeInfoDatum], log_pass: Bool) {
        let actual = combine_duplicates(datums: input).sorted {
            $0.distance != $1.distance ? $0.distance < $1.distance : $0.divided < $1.divided
        }
        let expectedSorted = expected.sorted {
            $0.distance != $1.distance ? $0.distance < $1.distance : $0.divided < $1.divided
        }
        
        if actual != expectedSorted {
            print("Test \"\(name)\" Failed!")
            print("Original:")
            for datum in input {
                print("  \(datum)")
            }
            print("Expected:")
            for datum in expectedSorted {
                print("  \(datum)")
            }
            print("Actual:")
            for datum in actual {
                print("  \(datum)")
            }
        } else {
            if log_pass {
                print("Test \"\(name)\" Passed!")
            }
        }
    }
    
}
