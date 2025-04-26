//
//  ALGORITHMS_2.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/24/25.
//

import Foundation

func getDrops(conveyors: [Conveyor]) -> [Drop] {
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
                if current_conveyor !== _previous_conveyor {
                    let span = Span(x1: previous_x, x2: current_x)
                    let drop = Drop(conveyor: _previous_conveyor, span: span)
                    result.append(drop)
                    previous_conveyor = current_conveyor
                    previous_x = current_x
                }
            } else {
                previous_conveyor = current_conveyor
                previous_x = current_x
            }
        } else {
            if let _previous_conveyor = previous_conveyor {
                let span = Span(x1: previous_x, x2: current_x)
                let drop = Drop(conveyor: _previous_conveyor, span: span)
                result.append(drop)
                previous_conveyor = nil
                previous_x = current_x
            }
        }
    }
    return result
}

func findCollidersAndParents(conveyors: [Conveyor]) {
    
    var actions = [DropSweepAction]()
    for conveyor in conveyors {
        if (conveyor.x2 - conveyor.x1) > 1 {
            actions.append(DropSweepAction(x: conveyor.x1, conveyor: conveyor, type: .add))
            actions.append(DropSweepAction(x: conveyor.x2, conveyor: conveyor, type: .remove))
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
    
    for conveyor in conveyors {
        if let left_collider = conveyor.left_collider {
            left_collider.parents.insert(conveyor.index)
        }
        if let right_collider = conveyor.right_collider {
            right_collider.parents.insert(conveyor.index)
        }
    }
    
}

func registerDrops(conveyors: [Conveyor], drops: [Drop]) {
    for drop in drops {
        let conveyor = drop.conveyor
        conveyor.drop_spans.append(drop.span)
    }
}
