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
    
    var prev_conveyor: Conveyor?
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
            
            let interval = Interval.init(start: start, end: end)
            let span = Span.interval(interval)
            let drop = Drop.conveyor(span, current_conveyor)
            result.append(drop)
            
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
        
        
        prev_conveyor = current_conveyor
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
    
    let heap = MaxheapIndexedHeap()
    
    var actionIndex = 0
    
    var previous_x = 0
    var previous_conveyor: Conveyor?
    
    while actionIndex < actions.count {
        
        var nextIndex = actionIndex + 1
        while nextIndex < actions.count && actions[nextIndex].x == actions[actionIndex].x {
            nextIndex += 1
        }
        
        var current_x = 0
        var list = [ConveyorSweepAction]()
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            list.append(action)
            current_x = action.x
            switch action.type {
            case .add:
                heap.insert(action.conveyor)
            case .remove:
                heap.remove(action.conveyor)
            }
            actionIndex += 1
        }
        
        if let current_conveyor = heap.peek() {
            //print("SSLOG => current_x = \(current_x), Now what?, conv = \(current_conveyor.name)")
            
            
            if let _previous_conveyor = previous_conveyor {
                
                if current_conveyor === _previous_conveyor {
                    
                } else {
                    if previous_x == current_x {
                        fatalError("Not expected to be possible that previous_x == current_x")
                    }
                    
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
                        let drop = Drop.empty(span)
                        result.append(drop)
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
            //print("SSLOG => current_x = \(current_x), Now what?, conv = NULL")
            
            if let _previous_conveyor = previous_conveyor {
                
                if previous_x == current_x {
                    fatalError("This should never happen, previous_x == current_x")
                }
                
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
            } else {
                fatalError("Is this possible? There isn't a previous conveyor, but we're processing the first one.")
                
            }
        }
    }
    
    if previous_x == max_x {
        //print("In this case, we end on the last converter.")
        let span = Span.point(max_x)
        let drop = Drop.empty(span)
        //print("Appending (CON) drop for good: \(drop)")
        result.append(drop)
    } else {
        let start = Boundary.closed(previous_x)
        let end = Boundary.closed(max_x)
        let interval = Interval(start: start, end: end)
        let span = Span.interval(interval)
        let drop = Drop.empty(span)
        //print("Appending (CON) drop for good: \(drop)")
        result.append(drop)
    }
    
    // These are the types of transitions:
    
    //---------------------------
    //
    //     [ c0 ]
    //     ..................
    //---------------------------
    //     In this case, we can do an empty drop at 0..
    //     In this case, we can do (c0.x1, x0.x2)
    //     In this case, we can do an empty drop at [c0.x2, end]
    
    //---------------------------
    //
    //         [ c0 ]
    //     ..................
    //---------------------------
    //     In this case, we can do an empty drop at [0, c0.x1]
    //     In this case, we can do (c0.x1, x0.x2)
    //     In this case, we can do an empty drop at [c0.x2, end]
    
    //---------------------------
    //
    //     [   c0   ]
    //            [   c1   ]
    //     ..................
    //---------------------------
    //     In this case, we can do a c0 drop at (c0.x1, c0.x2)
    //     In this case, we can do a c1 drop at [c0.x2, c1.x2)
    
    //---------------------------
    //
    //     [   c0   ]
    //              [   c1   ]
    //     ..................
    //---------------------------
    //     In this case, we can do a c0 drop at (c0.x1, c0.x2)
    //     In this case, we can do an empty drop at c0.x2
    //     In this case, we can do a c1 drop at (c1.x1, c1.x2)
    
    //---------------------------
    //
    //     [   c0   ]    [   c1   ]
    //            [   c2   ]
    //     ..................
    //---------------------------
    //     In this case, we can do a c0 drop at (c0.x1, c0.x2)
    //     In this case, we can do a c2 drop at [c0.x2, c1.x1]
    //     In this case, we can do a c1 drop at (c1.x1, c1.x2)
    
    //print("Conveyor Sweep Actions: \(actions.count)")
    for action in actions {
    //    print(action)
    }
    
    
    return result
}
