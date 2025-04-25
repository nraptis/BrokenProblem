//
//  Conveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class Conveyor: CustomStringConvertible {
    
    func full_cost() -> Double {
        
        var result_left = Double(0.0)
        var result_right = Double(0.0)
        
        for span in dropSpans {
            let cost_left = self.average_left(span: span)
            let cost_right = self.average_right(span: span)
            result_left += cost_left
            result_right += cost_right
        }
        
        for fall in falls {
            let cost_left = self.fall_value_left(fall: fall)
            let cost_right = self.fall_value_right(fall: fall)
            result_left += cost_left
            result_right += cost_right
        }
        
        
        let portion_left = (result_left)
        let portion_right = (result_right)
        
        let additional_left: Double
        if let left_collider = left_collider {
            let fall_left = portion_left
            let fall = Fall(x: x1, amount: fall_left)
            additional_left = left_collider.full_cost(fall: fall)
        } else {
            additional_left = 0.0
        }
        
        let additional_right: Double
        if let right_collider = right_collider {
            let fall_right = portion_right
            let fall = Fall(x: x1, amount: fall_right)
            additional_right = right_collider.full_cost(fall: fall)
        } else {
            additional_right = 0.0
        }
        
        return portion_left + portion_right + additional_left + additional_right
    }
    
    func full_cost(fall: Fall) -> Double {
        // Half goes left, half goes right.
        
        let move_left = fall.x - x1
        let move_right = x2 - fall.x
        
        let cost_left = fall.amount + Double(move_left)
        let cost_right = fall.amount + Double(move_right)
        
        var result_left = cost_left
        if let left_collider = left_collider {
            let fall_left = Fall(x: x1, amount: 0.0)
            let extra = left_collider.full_cost(fall: fall_left)
            result_left += extra
        }
        
        var result_right = cost_right
        if let right_collider = right_collider {
            let fall_right = Fall(x: x2, amount: 0.0)
            let extra = right_collider.full_cost(fall: fall_right)
            result_right += extra
        }
        
        let result = (result_left + result_right) / 2.0
        print("full cost is \(result) from fall \(fall.x) | \(fall.amount)")
        return result
    }
    
    func full_cost_locked_left() -> Double {
        
        var result = Double(0.0)
        for span in dropSpans {
            let cost = self.average_left(span: span)
            result += cost
        }
        for fall in falls {
            let cost = self.fall_value_left(fall: fall)
            result += cost
        }
        if let left_collider = left_collider {
            let fall = Fall(x: x1, amount: 0.0)
            let cost = left_collider.full_cost(fall: fall)
            result += cost
        }
        return result
    }
    
    func full_cost_locked_right() -> Double {
        var result = Double(0.0)
        for span in dropSpans {
            let cost = self.average_right(span: span)
            result += cost
        }
        for fall in falls {
            let cost = self.fall_value_right(fall: fall)
            result += cost
        }
        if let right_collider = right_collider {
            let fall = Fall(x: x2, amount: 0.0)
            let cost = right_collider.full_cost(fall: fall)
            result += cost
        }
        return result
    }
    
    
    
    static func clone(conveyors: [Conveyor]) -> [Conveyor] {
        var result = [Conveyor]()
        for (index, conveyor) in conveyors.enumerated() {
            let clone = Conveyor(name: conveyor.name,
                                 index: index,
                                 x1: conveyor.x1,
                                 x2: conveyor.x2,
                                 y: conveyor.y)
            result.append(clone)
        }
        return result
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
    
    let index: Int
    
    var heapIndex = 0
    
    let name: String
    let y: Int
    let x1: Int
    let x2: Int
    
    var dropSpans = [Span]()
    
    var fall_sum_left = Double(0.0)
    var fall_sum_right = Double(0.0)
    
    // This is from our selfs.
    var fall_cost_random = Double(0.0)
    var fall_cost_fixed_left = Double(0.0)
    var fall_cost_fixed_right = Double(0.0)
    
    // This is from parent conveyors that fall to us.
    var falls = [Fall]()
    
    var remaining_movement_left = Double(0.0)
    var remaining_movement_right = Double(0.0)
    
    // Uniform means that
    var cost_left_memo: Double = INVALID
    var cost_right_memo: Double = INVALID
    
    var left_collider: Conveyor?
    var right_collider: Conveyor?
    
    init(name: String, index: Int, x1: Int, x2: Int, y: Int) {
        let _x1 = min(x1, x2)
        let _x2 = max(x1, x2)
        self.name = name
        self.index = index;self.y = y;self.x1 = _x1; self.x2 = _x2
    }
    
    func fall_value_right(fall: Fall) -> Double {
        
        var exists = false
        for _fall in falls {
            if _fall === fall {
                exists = true
            }
        }
        if !exists {
            fatalError("This should be called on conveyor who owns fall.")
        }
        
        let distance = self.x2 - fall.x
        let amount = fall.amount
        let result = amount + Double(distance)
        return result
    }
    
    func fall_value_left(fall: Fall) -> Double {
        
        var exists = false
        for _fall in falls {
            if _fall === fall {
                exists = true
            }
        }
        if !exists {
            fatalError("This should be called on conveyor who owns fall.")
        }
        
        let distance = fall.x - self.x1
        let amount = fall.amount
        let result = amount + Double(distance)
        return result
    }
    
    func fall_value_right_CASCADE(fall: Fall) -> Double {
        let distance = self.x2 - fall.x
        let amount = fall.amount
        let result = amount + Double(distance)
        return result
    }
    
    func fall_value_left_CASCADE(fall: Fall) -> Double {
        let distance = fall.x - self.x1
        let amount = fall.amount
        let result = amount + Double(distance)
        return result
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
    
    func average_left(span: Span) -> Double {
        
        if span.is_range {
            let sample = average_all_smart(x1: span.x1, x2: span.x2, direction: .left)
            return sample
        } else {
            return 0.0
        }
    }
    
    func average_right(span: Span) -> Double {
        if span.is_range {
            let sample = average_all_smart(x1: span.x1, x2: span.x2, direction: .right)
            return sample
        } else {
            return 0.0
        }
    }
    
    static func count(span: Span) -> Int {
        if span.is_range {
            let result = (span.x2 - span.x1)
            return result
        } else {
            return 0
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

