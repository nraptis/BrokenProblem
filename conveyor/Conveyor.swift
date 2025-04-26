//
//  Conveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class Conveyor: CustomStringConvertible {
    
    static func children(conveyor: Conveyor) -> [Conveyor] {
        var exists = Set<Int>()
        var result = [Conveyor]()
        var stack = [Conveyor]()
        
        exists.insert(conveyor.index) // Mark starting node visited
        stack.append(conveyor)
        
        while stack.count > 0 {
            guard let top = stack.popLast() else { break }
            
            if top.index != conveyor.index {
                result.append(top)
            }
            
            if let left_collider = top.left_collider, !exists.contains(left_collider.index) {
                exists.insert(left_collider.index)
                stack.append(left_collider)
            }
            if let right_collider = top.right_collider, !exists.contains(right_collider.index) {
                exists.insert(right_collider.index)
                stack.append(right_collider)
            }
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
    
    var drop_spans = [Span]()
    
    var mixed_black_holes_original = [DropBlackHole]()
    
    var fall_black_holes_original = [DropBlackHole]()
    var fall_black_holes_modified = [DropBlackHole]()
    
    //var drop_black_holes_modified = [DropBlackHole]()
    
    
    var remaining_movement_left = Double(0.0)
    var remaining_movement_right = Double(0.0)
    
    // Uniform means that
    var cost_left_memo: Double = INVALID
    var cost_right_memo: Double = INVALID
    
    var left_collider: Conveyor?
    var right_collider: Conveyor?
    
    var parents = Set<Int>()
    
    init(name: String, index: Int, x1: Int, x2: Int, y: Int) {
        let _x1 = min(x1, x2)
        let _x2 = max(x1, x2)
        self.name = name
        self.index = index;self.y = y;self.x1 = _x1; self.x2 = _x2
    }
    
    /*
     func fall_value_right(fall: Fall) -> Double {
     
     let distance = self.x2 - fall.x
     let amount = fall.amount
     let result = amount + Double(distance)
     return result
     }
     
     func fall_value_left(fall: Fall) -> Double {
     
     let distance = fall.x - self.x1
     let amount = fall.amount
     let result = amount + Double(distance)
     return result
     }
     */
    
    private static func integrate_left(x1: Int, x2: Int) -> Double {
        let right_x = max(x1, x2)
        let left_x = min(x1, x2)
        let count = right_x - left_x + 1
        if count <= 0 { return 0.0 }
        let first = left_x - x1
        let last = right_x - x1
        let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
        return Double(sum) / Double(count)
    }
    
    private func integrate_left(x1: Int, x2: Int) -> Double {
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        let count = right_x - left_x + 1
        if count <= 0 { return 0.0 }
        let first = left_x - self.x1
        let last = right_x - self.x1
        let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
        return Double(sum) / Double(count)
    }
    
    private func integrate_right(x1: Int, x2: Int) -> Double {
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        let count = right_x - left_x + 1
        if count <= 0 { return 0.0 }
        let first = self.x2 - right_x
        let last = self.x2 - left_x
        let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
        return Double(sum) / Double(count)
    }
    
    private func sumup(n: Int) -> Int {
        (n * (n + 1)) >> 1
    }
    
    func average_left(span: Span) -> Double { integrate_left(x1: span.x1, x2: span.x2) }
    func average_right(span: Span) -> Double { integrate_right(x1: span.x1, x2: span.x2) }
    
    static func center(x1: Int, x2: Int) -> Double { Double(x1 + x2) / 2.0 }
    
    static func center(span: Span) -> Double { center(x1: span.x1, x2: span.x2) }
    
    static func mass(span: Span) -> Double {
        
        let result = Conveyor.integrate_left(x1: span.x1, x2: span.x2)
        return result
    }
    
    func distance_left(span: Span) -> Double {
        let center = Conveyor.center(span: span)
        let distance = center - Double(x1)
        return distance
    }

    func distance_right(span: Span) -> Double {
        let center = Conveyor.center(span: span)
        let distance = Double(x2) - center
        return distance
    }

    func distance_random(span: Span) -> Double {
        let left = distance_left(span: span)
        let right = distance_right(span: span)
        let distance = (left + right) / 2.0
        return distance
    }
    
    func distance_left(drop_black_hole: DropBlackHole) -> Double { distance_left(x: drop_black_hole.x) }
    func distance_right(drop_black_hole: DropBlackHole) -> Double { distance_right(x: drop_black_hole.x) }
    func distance_random(drop_black_hole: DropBlackHole) -> Double { distance_random(x: drop_black_hole.x) }
    
    
    func distance_left(x: Double) -> Double {
        let distance = x - Double(x1)
        return distance
    }

    func distance_right(x: Double) -> Double {
        let distance = Double(x2) - x
        return distance
    }

    func distance_random(x: Double) -> Double {
        let left = distance_left(x: x)
        let right = distance_right(x: x)
        let distance = (left + right) / 2.0
        return distance
    }
    
    static func count(span: Span) -> Int {
        let result = (span.x2 - span.x1)
        if result <= 0 {
            fatalError("span should not have 0 length, count function fails")
        }
        return result
    }
    
    static func percent(span: Span, multiplier: Double) -> Double {
        (Double(count(span: span)) * multiplier) / Double(1_000_000)
    }
    
    func ingest_fall_black_hole_original(black_hole_mass: Double,
                                         black_hole_distance: Double,
                                         black_hole_center: Double) {
        
        let fall_black_hole = DropBlackHole(x: black_hole_center,
                                            distance: black_hole_distance,
                                            mass: black_hole_mass)
        fall_black_holes_original.append(fall_black_hole)

        if let left_collider = left_collider {
            left_collider.ingest_fall_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                          black_hole_distance: black_hole_distance + black_hole_center - Double(x1),
                                                          black_hole_center: Double(x1))
        }
        if let right_collider = right_collider {
            right_collider.ingest_fall_black_hole_original(black_hole_mass: black_hole_mass / 2.0,
                                                           black_hole_distance: black_hole_distance + Double(x2) - black_hole_center,
                                                           black_hole_center: Double(x2))
        }
    }
    
    
}
