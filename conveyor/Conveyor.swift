//
//  Conveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class Conveyor: Hashable, CustomStringConvertible {
    
    static let INVALID = Double(-100_000_000.0)
    
    let name: String
    let index: Int
    
    var heapIndex = 0
    
    let y: Int
    let x1: Int
    let x2: Int
    
    var dropSpans = [Span]()
    
    // This is from our selfs.
    var fall_cost_left_normal = Double(0.0)
    var fall_cost_right_normal = Double(0.0)
    
    var fall_cost_left_fixed_left = Double(0.0)
    var fall_cost_right_fixed_right = Double(0.0)
    
    var local_cost_left_normal = Double(0.0)
    var local_cost_right_normal = Double(0.0)
    
    var fall_sum_left = Double(0.0)
    var fall_sum_right = Double(0.0)
    
    
    
    // This is from parent conveyors that fall to us.
    var falls = [Fall]()
    
    
    var remaining_movement_left = Double(0.0)
    var remaining_movement_right = Double(0.0)
    
    // Uniform means that
    var cost_left_uniform: Double = INVALID
    var cost_right_uniform: Double = INVALID
    
    var left_collider: Conveyor?
    var right_collider: Conveyor?
    
    
    init(name: String, index: Int, x1: Int, x2: Int, y: Int) {
        let _x1 = min(x1, x2)
        let _x2 = max(x1, x2)
        self.name = name;self.index = index;self.y = y;self.x1 = _x1; self.x2 = _x2
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
    
    static func ==(lhs: Conveyor, rhs: Conveyor) -> Bool {
        lhs.index == rhs.index
    }
    
    // A package can be considered to occupy a single point on the plane. If a package lands strictly
    // within conveyor belt i (excluding its endpoints), then it will be transported to its left or right end
    func between(x: Int) -> Bool {
        if x > x1 && x < x2 {
            return true
        } else {
            return false
        }
    }
    
    func below(y: Int) -> Bool {
        if y > self.y {
            return true
        } else {
            return false
        }
    }

    func average_all_smart(x1: Int, x2: Int, direction: Direction) -> Double {
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        
        let count = right_x - left_x + 1
        if count <= 0 { return 0.0 }
        
        switch direction {
        case .left:
            // summing (x - x1) from x in [left_x...right_x]
            let first = left_x - self.x1
            let last = right_x - self.x1
            let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
            return Double(sum) / Double(count)
            
        case .right:
            // summing (x2 - x) from x in [left_x...right_x]
            let first = self.x2 - right_x
            let last = self.x2 - left_x
            let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
            return Double(sum) / Double(count)
        }
    }
    
    var description: String {
        
        if let left_collider = left_collider {
            if let right_collider = right_collider {
                return "{\(name), [\(x1) to \(x2), y=\(y)] left: \(left_collider.name) right: \(right_collider.name)}"
            } else {
                return "{\(name), [\(x1) to \(x2), y=\(y)] left: \(left_collider.name)}"
            }
        } else if let right_collider = right_collider {
            return "{\(name), [\(x1) to \(x2), y=\(y)] right: \(right_collider.name)}"
        } else {
            return "{\(name), [\(x1) to \(x2), y=\(y)]}"
        }
        
        
    }
    
    func average_left(span: Span) -> Double {
        switch span {
        case .point:
            // This occupies 0% of the whole thing on a continuous scale.
            return 0.0
        case .interval(let interval):
            let start = interval.start
            let end = interval.end
            let range_start: Int
            let sample_start: Int
            switch start {
            case .closed(let number):
                range_start = number
                sample_start = number
            case .open(let number):
                range_start = number
                sample_start = number
            }
            let range_end: Int
            let sample_end: Int
            switch end {
            case .closed(let number):
                range_end = number
                sample_end = number
            case .open(let number):
                range_end = number
                sample_end = number
            }
            let count = (range_end - range_start)
            if count <= 0 {
                return 0.0
            }
            let sample = average_all_smart(x1: sample_start, x2: sample_end, direction: .left)
            return sample
        }
    }
    
    func average_right(span: Span) -> Double {
        switch span {
        case .point:
            // This occupies 0% of the whole thing on a continuous scale.
            return 0.0
        case .interval(let interval):
            let start = interval.start
            let end = interval.end
            let range_start: Int
            let sample_start: Int
            switch start {
            case .closed(let number):
                range_start = number
                sample_start = number
            case .open(let number):
                range_start = number
                sample_start = number
            }
            let range_end: Int
            let sample_end: Int
            switch end {
            case .closed(let number):
                range_end = number
                sample_end = number
            case .open(let number):
                range_end = number
                sample_end = number
            }
            let count = (range_end - range_start)
            if count <= 0 {
                return 0.0
            }
            let sample = average_all_smart(x1: sample_start, x2: sample_end, direction: .right)
            return sample
        }
    }
    
    static func count(span: Span) -> Int {
        switch span {
        case .point:
            // This occupies 0% of the whole thing on a continuous scale.
            return 0
        case .interval(let interval):
            let start = interval.start
            let end = interval.end
            let range_start: Int
            switch start {
            case .closed(let number):
                range_start = number
            case .open(let number):
                range_start = number
            }
            let range_end: Int
            switch end {
            case .closed(let number):
                range_end = number
            case .open(let number):
                range_end = number
            }
            let count = (range_end - range_start)
            return count
        }
    }
    
    static func percent(span: Span, multiplier: Double) -> Double {
        let count = count(span: span)
        if count <= 0 {
            return 0.0
        }
        return (Double(count) * multiplier) / Double(1_000_000)
    }
    
}
