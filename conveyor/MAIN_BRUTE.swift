//
//  MAIN_BRUTE.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/26/25.
//

import Foundation

func getMinExpectedHorizontalTravelDistance_BruteForce(conveyors: [Conveyor]) -> Double {
    findColliders(conveyors: conveyors)
    let drops = getDrops(conveyors: conveyors)
    registerDrops(conveyors: conveyors, drops: drops)
    findRemainingMovement(conveyors: conveyors)
    var result = Double(100_000_000_000_000.0)
    for locked_conveyor in conveyors {
        let directions = [Direction.left, Direction.right]
        for locked_direction in directions {
            for conveyor in conveyors {
                conveyor.cost_left_memo = INVALID
                conveyor.cost_right_memo = INVALID
            }
            let cost = getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                              drops: drops,
                                                              locked_conveyor: locked_conveyor,
                                                              locked_direction: locked_direction)
            if cost < result {
                result = cost
            }
        }
    }
    return result
}

func getMinExpectedHorizontalTravelDistance_BruteForce(_ N: Int, _ H: [Int], _ A: [Int], _ B: [Int]) -> Float {
    var conveyors = [Conveyor]()
    for index in 0..<N {
        let y = H[index]; let x1 = A[index]; let x2 = B[index]
        let conveyor = Conveyor(index: index, x1: x1, x2: x2, y: y)
        conveyors.append(conveyor)
    }
    return Float(getMinExpectedHorizontalTravelDistance_BruteForce(conveyors: conveyors))
}

func getMinExpectedHorizontalTravelDistance_Simulation(conveyors: [Conveyor]) -> Double {

    // This has been tested to death; I am cetain that it's correct.
    findColliders(conveyors: conveyors)
    
    // This has been tested to death; I am cetain that it's correct.
    let drops = getDrops(conveyors: conveyors)
    registerDrops(conveyors: conveyors, drops: drops)
    
    var result = Double(100_000_000_000_000.0)
    
    // Return Value ==> This is how far that the package is expected to travel in total once it lands at 'x' on 'conveyor'
    // Input Variable, x ==> This is the exact x position where the package lands.
    // Input Variable, conveyor ==> This is the conveyor we are landing on. We land at the exact location x.
    // Input Variable, locked_conveyor ==> This is the conveyor belt that is chosen to run at direction "locked_direction" with 100% certainty.
    // Input Variable, locked_direction ==> This is the direction that "locked_conveyor" is running at with 100% certainty.
    func bubble(x: Int,
                conveyor: Conveyor?,
                locked_conveyor: Conveyor,
                locked_direction: Direction) -> Double {
        
        guard let conveyor = conveyor else {
            return 0.0
        }
        
        // The conveyor lands at x, then it will have to travel "left_distance" units to the left before it leaves this conveyor.
        let left_distance = (x - conveyor.x1)
        
        // The conveyor lands at x, then it will have to travel "right_distance" units to the right before it leaves this conveyor.
        let right_distance = (conveyor.x2 - x)
        
        // Once the package falls off the left side, it will have to travel "left_remaining" additional units on average.
        let left_remaining = bubble(x: conveyor.x1,
                                    conveyor: conveyor.left_collider,
                                    locked_conveyor: locked_conveyor,
                                    locked_direction: locked_direction)
        
        // Once the package falls off the right side, it will have to travel "right_remaining" additional units on average.
        let right_remaining = bubble(x: conveyor.x2,
                                   conveyor: conveyor.right_collider,
                                   locked_conveyor: locked_conveyor,
                                   locked_direction: locked_direction)
        
        // The package travels an expected "left" units, if this conveyor goes to the left.
        let left = Double(left_distance) + left_remaining
        
        // The package travels an expected "right" units, if this conveyor goes to the right.
        let right = Double(right_distance) + right_remaining
        
        if conveyor.index == locked_conveyor.index {
            switch locked_direction {
            case .left:
                
                return left
            case .right:
                
                return right
            }
        } else {
            // It is not known if this conveyor goes to the right or the left,
            // so it is expected to travel exactly the average of "left" and "right"
            // *POSSIBLE OVERSIGT* Is this good math or bad, does it make sense?
            let average = (left + right) / 2.0
            return average
        }
    }
    
    for locked_conveyor in conveyors {
        let directions = [Direction.left, Direction.right]
        for locked_direction in directions {
            
            var grand_totals = [Double]()
            var counts = [Int]()
            
            for conveyor in conveyors {
                for span in conveyor.drop_spans {
                    
                    // If a package lands in *this* drop-span, on average, it will travel an additional "left_distance" units before falling off the conveyor.
                    // *POSSIBLE OVERSIGT* Is this good math or bad, does it make sense?
                    let left_distance = conveyor.average_left(span: span)
                    
                    // If a package lands in *this* drop-span, on average, it will travel an additional "right_distance" units before falling off the conveyor.
                    // *POSSIBLE OVERSIGT* Is this good math or bad, does it make sense?
                    let right_distance = conveyor.average_right(span: span)
                    
                    // Once the package falls off the left side, it will have to travel "left_remaining" additional units on average.
                    let left_remaining = bubble(x: conveyor.x1,
                                                conveyor: conveyor.left_collider,
                                                locked_conveyor: locked_conveyor,
                                                locked_direction: locked_direction)
                    
                    // Once the package falls off the right side, it will have to travel "right_remaining" additional units on average.
                    let right_remaining = bubble(x: conveyor.x2,
                                               conveyor: conveyor.right_collider,
                                               locked_conveyor: locked_conveyor,
                                               locked_direction: locked_direction)
                    
                    // The package travels an expected "left" units, if this conveyor goes to the left.
                    let left = Double(left_distance) + left_remaining
                    
                    // The package travels an expected "right" units, if this conveyor goes to the right.
                    let right = Double(right_distance) + right_remaining
                    
                    if conveyor.index == locked_conveyor.index {
                        switch locked_direction {
                        case .left:
                            
                            // Out of the total [0, 1_000_000] drop range, "count" of them will be within this drop's span.
                            let count = Conveyor.count(span: span)
                            grand_totals.append(left)
                            counts.append(count)
                        case .right:
                            
                            // Out of the total [0, 1_000_000] drop range, "count" of them will be within this drop's span.
                            let count = Conveyor.count(span: span)
                            grand_totals.append(right)
                            counts.append(count)
                        }
                        
                    } else {
                        // It is not known if this conveyor goes to the right or the left,
                        // so it is expected to travel exactly the average of "left" and "right"
                        // *POSSIBLE OVERSIGT* Is this good math or bad, does it make sense?
                        let average = (left + right) / 2.0
                        // Out of the total [0, 1_000_000] drop range, "count" of them will be within this drop's span.
                        let count = Conveyor.count(span: span)
                        grand_totals.append(average)
                        counts.append(count)
                    }
                }
            }
            
            // I do not think there is any issue with this logic.
            // We're just taking the "expected travel distance" and "amount of the total drops within this range"
            // Then we multiply them together, so it's the combined weight of this whole "drop..."
            let MULI = 8_000_000
            let MUL = Double(MULI)
            var total = Double(0.0)
            for index in counts.indices {
                let gt = grand_totals[index]
                let count = counts[index]
                let percent = Double(count * MULI) / Double(1_000_000.0)
                
                if count > 0 {
                    let value = (gt * percent)
                    total += value
                }
            }
            
            total /= (MUL)
            
            if total < result {
                result = total
            }
            
        }
    }
    return result
}

func getMinExpectedHorizontalTravelDistance_Simulation(_ N: Int, _ H: [Int], _ A: [Int], _ B: [Int]) -> Float {
    
    var conveyors = [Conveyor]()
    for index in 0..<N {
        let y = H[index]; let x1 = A[index]; let x2 = B[index]
        let conveyor = Conveyor(index: index, x1: x1, x2: x2, y: y)
        conveyors.append(conveyor)
    }
    return Float(getMinExpectedHorizontalTravelDistance_Simulation(conveyors: conveyors))
}
