//
//  ALGORITHMS.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

func findRemainingMovement(conveyors: [Conveyor]) {
    
    let DEBUG = false
    
    let conveyors = conveyors.sorted { $0.y < $1.y }
    
    for conveyor in conveyors {
        let movement_left_piece_1: Double
        let movement_left_piece_2: Double
        let movement_left_piece_3: Double
        let movement_left_piece_4: Double
        if let left_collider = conveyor.left_collider {
            movement_left_piece_1 = Double(conveyor.x1 - left_collider.x1)
            movement_left_piece_2 = Double(left_collider.x2 - conveyor.x1)
            movement_left_piece_3 = left_collider.remaining_movement_left
            movement_left_piece_4 = left_collider.remaining_movement_right
        } else {
            movement_left_piece_1 = 0.0
            movement_left_piece_2 = 0.0
            movement_left_piece_3 = 0.0
            movement_left_piece_4 = 0.0
        }
        
        conveyor.remaining_movement_left = 0.0
        conveyor.remaining_movement_left += movement_left_piece_1
        conveyor.remaining_movement_left += movement_left_piece_2
        conveyor.remaining_movement_left += movement_left_piece_3
        conveyor.remaining_movement_left += movement_left_piece_4
        conveyor.remaining_movement_left /= 2.0
        
        let movement_right_piece_1: Double
        let movement_right_piece_2: Double
        let movement_right_piece_3: Double
        let movement_right_piece_4: Double
        if let right_collider = conveyor.right_collider {
            movement_right_piece_1 = Double(right_collider.x2 - conveyor.x2)
            movement_right_piece_2 = Double(conveyor.x2 - right_collider.x1)
            movement_right_piece_3 = right_collider.remaining_movement_left
            movement_right_piece_4 = right_collider.remaining_movement_right
        } else {
            movement_right_piece_1 = 0.0
            movement_right_piece_2 = 0.0
            movement_right_piece_3 = 0.0
            movement_right_piece_4 = 0.0
        }
        
        conveyor.remaining_movement_right = 0.0
        conveyor.remaining_movement_right += movement_right_piece_1
        conveyor.remaining_movement_right += movement_right_piece_2
        conveyor.remaining_movement_right += movement_right_piece_3
        conveyor.remaining_movement_right += movement_right_piece_4
        conveyor.remaining_movement_right /= 2.0
        
    }
    
    if DEBUG {
        print("</ Start With RemainingMovement>")
        for conveyor in conveyors.reversed() {
            print("$$$$ =>>>> $$$$$ ")
            print(">>>> \(conveyor.name)")
            print("remaining_movement_left = \(conveyor.remaining_movement_left)")
            print("remaining_movement_right = \(conveyor.remaining_movement_right)")
            print("$$$$ =>>>> $$$$$")
        }
        
        print("</ Done With RemainingMovement>")
        
        print("AAA")
    }
}

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

func registerDrops(conveyors: [Conveyor], drops: [Drop]) {
    
    let DEBUG = false
    
    
    
    for drop in drops {
        switch drop {
        case .empty:
            break
        case .conveyor(let span, let conveyor):
            conveyor.dropSpans.append(span)
        }
    }
    for conveyor in conveyors {
        for span in conveyor.dropSpans {
            //conveyor.drop_cost_left += conveyor.average_left(span: span)
            //conveyor.drop_cost_right += conveyor.average_right(span: span)
        }
    }
    
    
    if DEBUG {
        print("</ Start With RegisterDrops>")
        print(">>> Spans >>>")
        for conveyor in conveyors {
            print("Conveyor: \(conveyor.name), \(conveyor.dropSpans.count) dropSpans")
            for span in conveyor.dropSpans {
                print("\t\(span), cost_left \(conveyor.average_left(span: span)), cost_right \(conveyor.average_right(span: span))")
            }
        }
        print("</ Done With RegisterDrops>")
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
