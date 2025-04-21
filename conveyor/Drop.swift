//
//  Drop.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

enum Drop: Equatable, CustomStringConvertible {
    case empty(Span)
    case conveyor(Span, Conveyor)
    static func == (lhs: Drop, rhs: Drop) -> Bool {
        switch (lhs, rhs) {
        case (.empty(let ls), .empty(let rs)):
            return ls == rs
        case (.conveyor(let ls, let lc), .conveyor(let rs, let rc)):
            if ls != rs { return false }
            if lc != rc { return false }
            return true
        default:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .empty(let span):
            return "DropEmpty{ \(span) }"
        case .conveyor(let span, let conveyor):
            return "DropConveyor{ \(span) | \(conveyor.name) }"
        }
    }
}

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

func getDrops(conveyors: [Conveyor]) -> [Drop] {
    
    let max_x = 1_000_000
    
    var result = [Drop]()
    
    var actions = [ConveyorSweepAction]()
    for conveyor in conveyors {
        if (conveyor.x2 - conveyor.x1) > 1 {
            actions.append(.init(x: conveyor.x1, conveyor: conveyor, type: .add))
            actions.append(.init(x: conveyor.x2, conveyor: conveyor, type: .remove))
        }
    }
    actions.sort { $0.x < $1.x }
    
    let heap = MaxHeap()
    
    var actionIndex = 0
    
    var previous_x = 0
    var previous_conveyor: Conveyor?
    
    while actionIndex < actions.count {
        
        var nextIndex = actionIndex + 1
        while nextIndex < actions.count && actions[nextIndex].x == actions[actionIndex].x {
            nextIndex += 1
        }
        
        // First the drops:
        let startIndex = actionIndex
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            switch action.type {
            case .add:
                break
            case .remove:
                heap.remove(action.conveyor)
            }
            actionIndex += 1
        }
        
        // Get the top shelf.
        let top_shelf = heap.peek()
        
        // Now the adds.
        actionIndex = startIndex
        var current_x = 0
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            current_x = action.x
            switch action.type {
            case .add:
                heap.insert(action.conveyor)
            case .remove:
                break
            }
            actionIndex += 1
        }
        
        if let current_conveyor = heap.peek() {
            if let _previous_conveyor = previous_conveyor {
                if current_conveyor === _previous_conveyor {
                    
                } else {
                    
                    // We go along the conveyor from previous_x to current_x
                    let start: Boundary
                    
                    if previous_x == _previous_conveyor.x1 {
                        start = .open(previous_x)
                    } else {
                        start = .closed(previous_x)
                    }
                    
                    let end: Boundary
                    if current_x == _previous_conveyor.x2 {
                        end = .open(current_x)
                    } else {
                        end = .closed(current_x)
                    }
                    
                    let interval = Interval(start: start, end: end)
                    let span = Span.interval(interval)
                    let drop = Drop.conveyor(span, _previous_conveyor)
                    result.append(drop)
                    previous_conveyor = current_conveyor
                    previous_x = current_x
                    
                    if _previous_conveyor.x2 == current_conveyor.x1 {
                        let span = Span.point(current_conveyor.x1)
                        if let top_shelf = top_shelf {
                            let drop = Drop.conveyor(span, top_shelf)
                            result.append(drop)
                            
                        } else {
                            let drop = Drop.empty(span)
                            result.append(drop)
                        }
                    }
                }
            } else {
                if previous_x == current_x {
                    let span = Span.point(current_x)
                    let drop = Drop.empty(span)
                    result.append(drop)
                    previous_conveyor = current_conveyor
                    previous_x = current_x
                } else {
                    let start = Boundary.closed(previous_x)
                    let end = Boundary.closed(current_x)
                    let interval = Interval(start: start, end: end)
                    let span = Span.interval(interval)
                    let drop = Drop.empty(span)
                    result.append(drop)
                    previous_conveyor = current_conveyor
                    previous_x = current_x
                }
            }
        } else {
            if let _previous_conveyor = previous_conveyor {
                // We go along the conveyor from previous_x to current_x
                let start: Boundary
                if previous_x == _previous_conveyor.x1 {
                    start = .open(previous_x)
                } else {
                    start = .closed(previous_x)
                }
                let end = Boundary.open(current_x)
                let interval = Interval(start: start, end: end)
                let span = Span.interval(interval)
                let drop = Drop.conveyor(span, _previous_conveyor)
                
                result.append(drop)
                previous_conveyor = nil
                previous_x = current_x
            }
        }
    }
    
    if previous_x == max_x {
        let span = Span.point(max_x)
        let drop = Drop.empty(span)
        result.append(drop)
    } else {
        let start = Boundary.closed(previous_x)
        let end = Boundary.closed(max_x)
        let interval = Interval(start: start, end: end)
        let span = Span.interval(interval)
        let drop = Drop.empty(span)
        result.append(drop)
    }
    
    return result
}
