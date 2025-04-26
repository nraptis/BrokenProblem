//
//  Conveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class Conveyor {
    
    static func clone(conveyors: [Conveyor]) -> [Conveyor] {
        var result = [Conveyor]()
        for (index, conveyor) in conveyors.enumerated() {
            let clone = Conveyor(index: index,
                                 x1: conveyor.x1,
                                 x2: conveyor.x2,
                                 y: conveyor.y)
            result.append(clone)
        }
        return result
    }
    
    let index: Int
    
    var heapIndex = 0
    
    let y: Int
    let x1: Int
    let x2: Int
    
    var drop_spans = [Span]()
    
    var remaining_movement_left = Double(0.0)
    var remaining_movement_right = Double(0.0)
    
    var cost_left_memo: Double = INVALID
    var cost_right_memo: Double = INVALID
    
    var left_collider: Conveyor?
    var right_collider: Conveyor?
    
    var cozt_left = Double(0.0)
    var cozt_right = Double(0.0)
    var cozt_random = Double(0.0)
    
    var black_holes = [DropBlackHole]()
    
    init(index: Int, x1: Int, x2: Int, y: Int) {
        let _x1 = min(x1, x2)
        let _x2 = max(x1, x2)
        self.index = index;self.y = y;self.x1 = _x1; self.x2 = _x2
    }
    
    private static func integrate_left_zero(x1: Int, x2: Int) -> Double {
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
    
    func average_left(span: Span) -> Double {
        integrate_left(x1: span.x1, x2: span.x2)
    }
    
    func average_right(span: Span) -> Double {
        integrate_right(x1: span.x1, x2: span.x2)
    }
    
    static func center(x1: Int, x2: Int) -> Double {
        Double(x1 + x2) / 2.0
    }
    
    static func center(span: Span) -> Double {
        center(x1: span.x1, x2: span.x2)
    }
    
    static func mass(span: Span) -> Double {
        let result = Conveyor.integrate_left_zero(x1: span.x1, x2: span.x2)
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
        return result
    }
    
    static func percent(span: Span, multiplier: Double) -> Double {
        (Double(count(span: span)) * multiplier) / Double(1_000_000)
    }
    
    func ingest_black_hole(black_hole_mass: Double,
                      black_hole_distance: Double,
                      black_hole_center: Double) {
        let black_hole = DropBlackHole(x: black_hole_center,
                                       distance: black_hole_distance,
                                       mass: black_hole_mass)
        black_holes.append(black_hole)
    }
    
}

