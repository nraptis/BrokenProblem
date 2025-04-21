//
//  StreakTest.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class StreakTest {
    
    /*
    static func run_sum() {
        
        let test1 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test1_passes = 0
        
        for _ in 0..<1000 {
            let x = Int.random(in: test1.x1...test1.x2)
            let direction = Direction.left
            let score1 = test1.sum_all_brute(x: x, direction: direction)
            let score2 = test1.sum_all_smart(x: x, direction: direction)
            if score1 != score2 {
                print("For test [0...100] at x: \(x), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test1_passes += 1
            }
        }
        print("Steak Tests, test1_passes = \(test1_passes)")
        
        let test2 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test2_passes = 0
        for _ in 0..<1000 {
            let x = Int.random(in: test2.x1...test2.x2)
            let direction = Direction.right
            let score1 = test2.sum_all_brute(x: x, direction: direction)
            let score2 = test2.sum_all_smart(x: x, direction: direction)
            if score1 != score2 {
                print("For test [0...100] at x: \(x), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test2_passes += 1
            }
        }
        print("Steak Tests, test2_passes = \(test2_passes)")
        
        
        for _ in 0..<100 {
            var test3_passes = 0
            for tid in 2..<1000 {
                let test3 = Conveyor(index: tid, x1: Int.random(in: 0...1000), x2: Int.random(in: 0...1000), y: 10)
                for _ in 0..<1000 {
                    let x = Int.random(in: test3.x1...test3.x2)
                    let direction: Direction
                    if Bool.random() {
                        direction = .left
                    } else {
                        direction = .right
                    }
                    let score1 = test3.sum_all_brute(x: x, direction: direction)
                    let score2 = test3.sum_all_smart(x: x, direction: direction)
                    if score1 != score2 {
                        print("For test [0...100] at x: \(x), direction: \(direction), expected: \(score1), got: \(score2)")
                        return
                    } else {
                        test3_passes += 1
                    }
                }
            }
            print("Steak Tests, test3_passes = \(test3_passes)")
        }
    }
    
    static func run_average() {
        
        let test1 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test1_passes = 0
        
        for _ in 0..<1000 {
            let x = Int.random(in: test1.x1...test1.x2)
            let direction = Direction.left
            let score1 = test1.average_all_brute(x: x, direction: direction)
            let score2 = test1.average_all_smart(x: x, direction: direction)
            if abs(score1 - score2) > 0.01 {
                print("For test [0...100] at x: \(x), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test1_passes += 1
            }
        }
        print("Steak Tests, test1_passes = \(test1_passes)")
        
        let test2 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test2_passes = 0
        for _ in 0..<1000 {
            let x = Int.random(in: test2.x1...test2.x2)
            let direction = Direction.right
            let score1 = test2.average_all_brute(x: x, direction: direction)
            let score2 = test2.average_all_smart(x: x, direction: direction)
            if abs(score1 - score2) > 0.01 {
                print("For test [0...100] at x: \(x), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test2_passes += 1
            }
        }
        print("Steak Tests, test2_passes = \(test2_passes)")
        
        
        for _ in 0..<100 {
            var test3_passes = 0
            for tid in 2..<1000 {
                let test3 = Conveyor(index: tid, x1: Int.random(in: 0...1000), x2: Int.random(in: 0...1000), y: 10)
                for _ in 0..<1000 {
                    let x = Int.random(in: test3.x1...test3.x2)
                    let direction: Direction
                    if Bool.random() {
                        direction = .left
                    } else {
                        direction = .right
                    }
                    let score1 = test3.average_all_brute(x: x, direction: direction)
                    let score2 = test3.average_all_smart(x: x, direction: direction)
                    if abs(score1 - score2) > 0.01 {
                        print("For test [0...100] at x: \(x), direction: \(direction), expected: \(score1), got: \(score2)")
                        return
                    } else {
                        test3_passes += 1
                    }
                }
            }
            print("Steak Tests, test3_passes = \(test3_passes)")
        }
    }
    
    static func run_sum_2() {
        
        let test1 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test1_passes = 0
        
        for _ in 0..<1000 {
            let x1 = Int.random(in: test1.x1...test1.x2)
            let x2 = Int.random(in: test1.x1...test1.x2)
            
            let direction = Direction.left
            let score1 = test1.sum_all_brute(x1: x1, x2: x2, direction: direction)
            let score2 = test1.sum_all_smart(x1: x1, x2: x2, direction: direction)
            if score1 != score2 {
                print("For test [0...100] at x1: \(x1), x2: \(x2), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test1_passes += 1
            }
        }
        print("Steak Tests, test1_passes = \(test1_passes)")
        
        let test2 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test2_passes = 0
        for _ in 0..<1000 {
            let x1 = Int.random(in: test2.x1...test2.x2)
            let x2 = Int.random(in: test2.x1...test2.x2)
            let direction = Direction.right
            let score1 = test2.sum_all_brute(x1: x1, x2: x2, direction: direction)
            let score2 = test2.sum_all_smart(x1: x1, x2: x2, direction: direction)
            if score1 != score2 {
                print("For test [0...100] at at x1: \(x1), x2: \(x2), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test2_passes += 1
            }
        }
        print("Steak Tests, test2_passes = \(test2_passes)")
        
        
        for _ in 0..<100 {
            var test3_passes = 0
            for tid in 2..<1000 {
                let test3 = Conveyor(index: tid, x1: Int.random(in: 0...1000), x2: Int.random(in: 0...1000), y: 10)
                for _ in 0..<1000 {
                    let x1 = Int.random(in: test3.x1...test3.x2)
                    let x2 = Int.random(in: test3.x1...test3.x2)
                    let direction: Direction
                    if Bool.random() {
                        direction = .left
                    } else {
                        direction = .right
                    }
                    let score1 = test3.sum_all_brute(x1: x1, x2: x2, direction: direction)
                    let score2 = test3.sum_all_smart(x1: x1, x2: x2, direction: direction)
                    if score1 != score2 {
                        print("For test [0...100] at x1: \(x1), x2: \(x2), direction: \(direction), expected: \(score1), got: \(score2)")
                        return
                    } else {
                        test3_passes += 1
                    }
                }
            }
            print("Steak Tests, test3_passes = \(test3_passes)")
        }
    }
    
    static func run_average_2() {
        
        let test1 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test1_passes = 0
        
        for _ in 0..<1000 {
            let x1 = Int.random(in: test1.x1...test1.x2)
            let x2 = Int.random(in: test1.x1...test1.x2)
            let direction = Direction.left
            let score1 = test1.average_all_brute(x1: x1, x2: x2, direction: direction)
            let score2 = test1.average_all_smart(x1: x1, x2: x2, direction: direction)
            if abs(score1 - score2) > 0.01 {
                print("For test [0...100] at x1: \(x1), x2: \(x2), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test1_passes += 1
            }
        }
        print("Steak Tests, test1_passes = \(test1_passes)")
        
        let test2 = Conveyor(index: 0, x1: 0, x2: 100, y: 10)
        var test2_passes = 0
        for _ in 0..<1000 {
            let x1 = Int.random(in: test2.x1...test2.x2)
            let x2 = Int.random(in: test2.x1...test2.x2)
            let direction = Direction.right
            let score1 = test2.average_all_brute(x1: x1, x2: x2, direction: direction)
            let score2 = test2.average_all_smart(x1: x1, x2: x2, direction: direction)
            if abs(score1 - score2) > 0.01 {
                print("For test [0...100] at x1: \(x1), x2: \(x2), direction: \(direction), expected: \(score1), got: \(score2)")
                return
            } else {
                test2_passes += 1
            }
        }
        print("Steak Tests, test2_passes = \(test2_passes)")
        
        
        for _ in 0..<100 {
            var test3_passes = 0
            for tid in 2..<1000 {
                let test3 = Conveyor(index: tid, x1: Int.random(in: 0...1000), x2: Int.random(in: 0...1000), y: 10)
                for _ in 0..<1000 {
                    let x1 = Int.random(in: test3.x1...test3.x2)
                    let x2 = Int.random(in: test3.x1...test3.x2)
                    let direction: Direction
                    if Bool.random() {
                        direction = .left
                    } else {
                        direction = .right
                    }
                    let score1 = test3.average_all_brute(x1: x1, x2: x2, direction: direction)
                    let score2 = test3.average_all_smart(x1: x1, x2: x2, direction: direction)
                    if abs(score1 - score2) > 0.01 {
                        print("For test [0...100] at x1: \(x1), x2: \(x2), direction: \(direction), expected: \(score1), got: \(score2)")
                        return
                    } else {
                        test3_passes += 1
                    }
                }
            }
            print("Steak Tests, test3_passes = \(test3_passes)")
        }
    }
    */
    
}
