//
//  ALGORITHMS.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

func findColliders(conveyors: [Conveyor]) {
    
    var actions = [CollideSweepAction]()
    for conveyor in conveyors {
        if (conveyor.x2 - conveyor.x1) > 1 {
            actions.append(CollideSweepAction(x: conveyor.x1, conveyor: conveyor, type: .add))
            actions.append(CollideSweepAction(x: conveyor.x2, conveyor: conveyor, type: .remove))
        }
    }
    actions.sort { return $0.x < $1.x }
    
    let tree = AVLTree()
    var actionIndex = 0
    
    while actionIndex < actions.count {
        
        var nextIndex = actionIndex + 1
        while nextIndex < actions.count && actions[nextIndex].x == actions[actionIndex].x {
            nextIndex += 1
        }
        
        // First the removes, remove from the tree:
        let startIndex = actionIndex
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            switch action.type {
            case .add:
                break
            case .remove:
                let conveyor = action.conveyor
                tree.remove(conveyor)
            }
            actionIndex += 1
        }
        
        // Second the removes, calculate right colliders.
        actionIndex = startIndex
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            switch action.type {
            case .add:
                break
            case .remove:
                let conveyor = action.conveyor
                conveyor.right_collider = tree.best(y: conveyor.y)
            }
            actionIndex += 1
        }
        
        // Third the adds, calculate left colliders.
        actionIndex = startIndex
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            switch action.type {
            case .add:
                let conveyor = action.conveyor
                conveyor.left_collider = tree.best(y: conveyor.y)
            case .remove:
                break
            }
            actionIndex += 1
        }
        
        // Fourth the adds, add to the tree.
        actionIndex = startIndex
        while actionIndex < nextIndex {
            let action = actions[actionIndex]
            switch action.type {
            case .add:
                let conveyor = action.conveyor
                tree.insert(conveyor)
            case .remove:
                break
            }
            actionIndex += 1
        }
    }
}

func getDrops(conveyors: [Conveyor]) -> [Drop] {
    let max_x = 1_000_000
    var result = [Drop]()
    var actions = [DropSweepAction]()
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
