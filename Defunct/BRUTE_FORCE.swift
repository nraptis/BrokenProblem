//
//  BRUTE_FORCE.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/21/25.
//

import Foundation

func collide_innie(x: Int, y: Int, conveyors: [Conveyor]) -> Conveyor? {
    var result: Conveyor?
    for conveyor in conveyors {
        if x > conveyor.x1 && x < conveyor.x2 {
            if y > conveyor.y {
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
func collide_outie(x: Int, y: Int, conveyors: [Conveyor]) -> Conveyor? {
    var result: Conveyor?
    for conveyor in conveyors {
        if x >= conveyor.x1 && x <= conveyor.x2 {
            if y > conveyor.y {
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

func getDrops_brute_force(conveyors: [Conveyor]) -> [Drop] {
    
    var result = [Drop]()
    
    let conveyors = conveyors.filter {
        $0.x2 - $0.x1 > 1
    }
    
    if conveyors.count <= 0 {
        return result
    }
    
    var highest_x = 0
    var lowest_x = Int.max
    for conveyor in conveyors {
        lowest_x = min(lowest_x, conveyor.x1)
        highest_x = max(highest_x, conveyor.x2)
    }
    
    var innies = [Conveyor?](repeating: nil, count: 1_000_001)
    var outies = [Conveyor?](repeating: nil, count: 1_000_001)
    
    for x in lowest_x...highest_x {
        innies[x] = collide_innie(x: x, y: 1_000_000, conveyors: conveyors)
        outies[x] = collide_innie(x: x, y: 1_000_000, conveyors: conveyors)
    }
    
    var index = (lowest_x + 1)
    while index <= (highest_x - 1) {
        
        let current_conveyor = innies[index]
        
        var seek = index + 1
        
        if let current_conveyor = current_conveyor {
            while seek <= highest_x, let check_conveyor = innies[seek], check_conveyor.index == current_conveyor.index {
                seek += 1
            }
        } else {
            while seek <= highest_x, innies[seek] === nil {
                seek += 1
            }
        }
        
        var x1 = index
        var x2 = seek - 1
        
        if let current_conveyor = current_conveyor {
         
            // If this is the edge of the conveyor, include that.
            if outies[x1 - 1]?.index == current_conveyor.index {
                x1 -= 1
            }
            if outies[x2 + 1]?.index == current_conveyor.index {
                x2 += 1
            }
            
            if x1 >= x2 {
                let span = Span(x1: x1, x2: 0, is_range: false)
                let drop = Drop(conveyor: current_conveyor, span: span)
                result.append(drop)
            } else {
                let span = Span(x1: x1, x2: x2, is_range: true)
                let drop = Drop(conveyor: current_conveyor, span: span)
                result.append(drop)
            }
            
        }
        
        
        index = seek
    }

    return result
}

func collide(x: Int, y: Int, conveyors: [Conveyor]) -> Conveyor? {
    var result: Conveyor?
    for conveyor in conveyors {
        if x > conveyor.x1 && x < conveyor.x2 {
            if y > conveyor.y {
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


