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
        actions.append(.init(x: conveyor.x1, conveyor: conveyor, type: .add))
        actions.append(.init(x: conveyor.x2, conveyor: conveyor, type: .remove))
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

func findColliders(conveyors: [Conveyor]) {
    
    var actions = [DropSweepAction]()
    for conveyor in conveyors {
        
        actions.append(DropSweepAction(x: conveyor.x1, conveyor: conveyor, type: .add))
        actions.append(DropSweepAction(x: conveyor.x2, conveyor: conveyor, type: .remove))
        
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
    for drop in drops {
        let conveyor = drop.conveyor
        conveyor.drop_spans.append(drop.span)
    }
}

func ingest_cozts(conveyors: [Conveyor]) {
    let conveyors = conveyors.sorted { $0.y > $1.y }
    for conveyor in conveyors {
        let remaining_movement_left = conveyor.remaining_movement_left
        let remaining_movement_right = conveyor.remaining_movement_right
        let remaining_movement_random = (remaining_movement_left + remaining_movement_right) / 2.0
        for drop_span in conveyor.drop_spans {
            let black_hole_mass = Conveyor.mass(span: drop_span)
            let black_hole_center = Conveyor.center(span: drop_span)
            let distance_left = conveyor.distance_left(x: black_hole_center) + remaining_movement_left
            let distance_right = conveyor.distance_right(x: black_hole_center) + remaining_movement_right
            let distance_random = conveyor.distance_random(x: black_hole_center) + remaining_movement_random
            conveyor.cozt_left += black_hole_mass * distance_left
            conveyor.cozt_right +=  black_hole_mass * distance_right
            conveyor.cozt_random += black_hole_mass * distance_random
        }
        
        for black_hole in conveyor.black_holes {
            let black_hole_mass = black_hole.mass
            let black_hole_center = black_hole.x
            let distance_left = conveyor.distance_left(x: black_hole_center) + remaining_movement_left
            let distance_right = conveyor.distance_right(x: black_hole_center) + remaining_movement_right
            let distance_random = conveyor.distance_random(x: black_hole_center) + remaining_movement_random
            conveyor.cozt_left += black_hole_mass * distance_left
            conveyor.cozt_right +=  black_hole_mass * distance_right
            conveyor.cozt_random += black_hole_mass * distance_random
        }
        
        if let left_collider = conveyor.left_collider {
            
            var left_distances = [Double]()
            var left_masses = [Double]()
            for drop_span in conveyor.drop_spans {
                let black_hole_mass = Conveyor.mass(span: drop_span)
                let black_hole_center = Conveyor.center(span: drop_span)
                left_masses.append(black_hole_mass)
                left_distances.append(black_hole_center - Double(conveyor.x1))
            }
            
            for black_hole in conveyor.black_holes {
                let black_hole_mass = black_hole.mass
                let black_hole_center = black_hole.x
                let black_hole_distance = black_hole.distance
                left_masses.append(black_hole_mass)
                left_distances.append(black_hole_distance + black_hole_center - Double(conveyor.x1))
            }
            
            if left_masses.count > 0 {
                var combined_mass = Double(0.0)
                var sum_distances = Double(0.0)
                
                for index in 0..<left_masses.count {
                    combined_mass += left_masses[index]
                    sum_distances += (left_masses[index] * left_distances[index])
                }
                if combined_mass > 0.05 {
                    let combined_distance = sum_distances / combined_mass
                    left_collider.ingest_black_hole(black_hole_mass: combined_mass / 2.0,
                                               black_hole_distance: combined_distance,
                                               black_hole_center: Double(conveyor.x1))
                }
            }
        }
        
        if let right_collider = conveyor.right_collider {
            
            var right_distances = [Double]()
            var right_masses = [Double]()
            for drop_span in conveyor.drop_spans {
                let black_hole_mass = Conveyor.mass(span: drop_span)
                let black_hole_center = Conveyor.center(span: drop_span)
                right_masses.append(black_hole_mass)
                right_distances.append(Double(conveyor.x2) - black_hole_center)
            }
            
            for black_hole in conveyor.black_holes {
                let black_hole_mass = black_hole.mass
                let black_hole_center = black_hole.x
                let black_hole_distance = black_hole.distance
                right_masses.append(black_hole_mass)
                right_distances.append(black_hole_distance + Double(conveyor.x2) - black_hole_center)
            }
            
            if right_masses.count > 0 {
                var combined_mass = Double(0.0)
                var sum_distances = Double(0.0)
                
                for index in 0..<right_masses.count {
                    combined_mass += right_masses[index]
                    sum_distances += (right_masses[index] * right_distances[index])
                }
                if combined_mass > 0.05 {
                    let combined_distance = sum_distances / combined_mass
                    right_collider.ingest_black_hole(black_hole_mass: combined_mass / 2.0,
                                                black_hole_distance: combined_distance,
                                                black_hole_center: Double(conveyor.x2))
                    
                }
            }
        }
    }
}

