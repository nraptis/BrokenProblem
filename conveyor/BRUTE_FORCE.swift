//
//  BRUTE_FORCE.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

func getDrops_brute_force(conveyors: [Conveyor]) -> [Drop] {
    
    var result = [Drop]()
    
    let conveyors = conveyors.filter {
        $0.x2 - $0.x1 > 1
    }
    
    if conveyors.count <= 0 {
        let drop = Drop.empty(.interval(Interval(start: .closed(0), end: .closed(1_000_000))))
        result.append(drop)
        return result
    }
    
    var highest_x = 0
    var lowest_x = Int.max
    for conveyor in conveyors {
        lowest_x = min(lowest_x, conveyor.x1)
        highest_x = max(highest_x, conveyor.x2)
    }
    
    var landing = [Conveyor?](repeating: nil, count: 1_000_001)
    
    if lowest_x > 0 {
        let start = Boundary.closed(0)
        let end = Boundary.closed(lowest_x)
        let interval = Interval.init(start: start, end: end)
        let span = Span.interval(interval)
        let drop = Drop.empty(span)
        result.append(drop)
    } else {
        let span = Span.point(0)
        let drop = Drop.empty(span)
        result.append(drop)
    }
    
    for x in lowest_x...highest_x {
        let conveyor = collide(x: x, y: 1_000_000, conveyors: conveyors)
        landing[x] = conveyor
    }
    
    var index = (lowest_x + 1)
    while index <= (highest_x - 1) {
        
        let current_conveyor = landing[index]
        
        var seek = index + 1
        while seek <= highest_x && (landing[seek] == current_conveyor) {
            seek += 1
        }
        
        let x1 = index
        let x2 = seek - 1
        
        if let current_conveyor = current_conveyor {
            
            let start: Boundary
            if x1 == (current_conveyor.x1 + 1) {
                if x1 - 1 >= lowest_x {
                    if let prev = landing[x1 - 1] {
                        if prev.y > current_conveyor.y {
                            // We really moved to a lower conveyor here.
                            start = .closed(x1)
                        } else {
                            start = .open(current_conveyor.x1)
                        }
                    } else {
                        start = .open(current_conveyor.x1)
                    }
                } else {
                    start = .open(current_conveyor.x1)
                }
            } else {
                start = .closed(x1)
            }
            
            let end: Boundary
            if x2 == (current_conveyor.x2 - 1) {
                
                // If the next tile is a higher conveyor, this is closed.
                if x2 + 1 <= highest_x {
                    if let next = landing[x2 + 1] {
                        if next.y > current_conveyor.y {
                            // We really moved to a higher conveyor here.
                            end = .closed(x2)
                        } else {
                            end = .open(current_conveyor.x2)
                        }
                    } else {
                        end = .open(current_conveyor.x2)
                    }
                } else {
                    end = .open(current_conveyor.x2)
                }
            } else {
                end = .closed(x2)
            }
            
            // If these are the same and closed, make a point
            let single_point: Bool
            var sp_value = 0
            switch start {
            case .closed(let start_value):
                switch end {
                case .closed(let end_value):
                    if start_value == end_value {
                        single_point = true
                        sp_value = start_value
                    } else {
                        single_point = false
                    }
                case .open:
                    single_point = false
                }
            case .open:
                single_point = false
            }
            
            if single_point {
                let span = Span.point(sp_value)
                let drop = Drop.conveyor(span, current_conveyor)
                result.append(drop)
            } else {
                let interval = Interval.init(start: start, end: end)
                let span = Span.interval(interval)
                let drop = Drop.conveyor(span, current_conveyor)
                result.append(drop)
            }
        } else {
            
            if x1 == x2 {
                let span = Span.point(x1)
                let drop = Drop.empty(span)
                result.append(drop)
            } else {
                let start = Boundary.closed(x1)
                let end = Boundary.closed(x2)
                let interval = Interval.init(start: start, end: end)
                let span = Span.interval(interval)
                let drop = Drop.empty(span)
                result.append(drop)
            }
        }
        index = seek
    }
    
    if highest_x < 1_000_000 {
        let start = Boundary.closed(highest_x)
        let end = Boundary.closed(1_000_000)
        let interval = Interval.init(start: start, end: end)
        let span = Span.interval(interval)
        let drop = Drop.empty(span)
        result.append(drop)
    } else {
        let span = Span.point(1_000_000)
        let drop = Drop.empty(span)
        result.append(drop)
    }
    
    return result
}

func collide(x: Int, y: Int, conveyors: [Conveyor]) -> Conveyor? {
    var result: Conveyor?
    for conveyor in conveyors {
        if conveyor.between(x: x) {
            if conveyor.below(y: y) {
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

func findColliders_BruteForce(conveyors: [Conveyor]) {
    
    for conveyor in conveyors {
        if (conveyor.x2 - conveyor.x1) > 1 {
            conveyor.left_collider = collide(x: conveyor.x1, y: conveyor.y, conveyors: conveyors)
            conveyor.right_collider = collide(x: conveyor.x2, y: conveyor.y, conveyors: conveyors)
        }
    }
}


