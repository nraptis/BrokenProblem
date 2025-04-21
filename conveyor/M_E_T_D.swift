//
//  M_E_T_D.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

func getMinExpectedHorizontalTravelDistance(conveyors: [Conveyor],
                                            dropInfos: [DropInfo],
                                            locked_conveyor: Conveyor,
                                            locked_direction: Direction) -> Double {
    
    let total_drops = (1_000_000)
    
    enum Datum {
        struct DatumDataEmpty {
            let count: Int
        }
        struct DatumDataLeftLocked {
            let average: Double
            let count: Int
            let x_start: Int
            let x_end: Int
        }
        struct DatumDataRightLocked {
            let average: Double
            let count: Int
            let x_start: Int
            let x_end: Int
        }
        struct DatumDataRandom {
            let average_left: Double
            let average_right: Double
            let average: Double
            let count: Int
            let x_start: Int
            let x_end: Int
        }
        case empty(DatumDataEmpty)
        case left_locked(DatumDataLeftLocked)
        case right_locked(DatumDataRightLocked)
        case random(DatumDataRandom)
    }
    
    var datums = [Datum]()
    
    for dropInfo in dropInfos {
        
        switch dropInfo {
        case .empty(let data):
            //let count =
            break
        case .conveyor(let dropInfoData_Conveyor):
            break
        }
    }
    
    /*
    for conveyor_drop in conveyor_drops {
        
        let conveyor = conveyor_drop.conveyor
        let count = conveyor.count(conveyor_drop)
        if conveyor_drop.conveyor == locked_conveyor {
            // This is locked in the direction.
            switch locked_direction {
            case .left:
                let cost_left = conveyor.average_left(conveyor_drop)
                datums.append(.left_locked(.init(average: cost_left,
                                                 count: count,
                                                 x_start: conveyor_drop.x1,
                                                 x_end: conveyor_drop.x2)))
            case .right:
                let cost_right = conveyor.average_right(conveyor_drop)
                datums.append(.right_locked(.init(average: cost_right,
                                                  count: count,
                                                  x_start: conveyor_drop.x1,
                                                  x_end: conveyor_drop.x2)))
            }
        } else {
            let cost_left = conveyor.average_left(conveyor_drop)
            let cost_right = conveyor.average_right(conveyor_drop)
            let cost = (cost_right + cost_left) / 2.0
            datums.append(.random(.init(average_left: cost_left,
                                        average_right: cost_right,
                                        average: cost,
                                        count: count,
                                        x_start: conveyor_drop.x1,
                                        x_end: conveyor_drop.x2)))
        }
    }
    */
    
    print("The Datums: \(datums.count)")
    
    
    let MULTIPLIER_I: Int = 8_000_000
    let MULTIPLIER_D: Double = Double(MULTIPLIER_I)
    
    var result = Double(0.0)
    
    for datum in datums {
        
        switch datum {
        case .empty(let data):
            let percent = (Double(data.count * MULTIPLIER_I)) / Double(total_drops)
            print("\tEMPTY: \(data.count) spaces. pct: \(percent / MULTIPLIER_D)")
        case .left_locked(let data):
            
            let percent = (Double(data.count * MULTIPLIER_I)) / Double(total_drops)
            print("\tLEFT: \(data.average) average, \(data.count) spaces. x[\(data.x_start)...\(data.x_end)] pct: \(percent / MULTIPLIER_D)")
            result += data.average * percent
        case .right_locked(let data):
            
            let percent = (Double(data.count * MULTIPLIER_I)) / Double(total_drops)
            print("\tRIGHT: \(data.average) average, \(data.count) spaces. x[\(data.x_start)...\(data.x_end)] pct: \(percent / MULTIPLIER_D)")
            result += data.average * percent
        case .random(let data):
            
            let percent = (Double(data.count * MULTIPLIER_I)) / Double(total_drops)
            print("\tMIXED: \(data.average) average, \(data.count) spaces. x[\(data.x_start)...\(data.x_end)] (left component: \(data.average_left), right component: \(data.average_right)) pct: \(percent / MULTIPLIER_D)")
            result += data.average * percent
        }
        
    }
    
    return (result / MULTIPLIER_D)
}

/*
func getMinExpectedHorizontalTravelDistance(conveyors: [Conveyor], dropInfos: [DropInfo], locked_conveyor: Conveyor, locked_direction: Direction) -> Double {
    var empty_drops = [DropInfo.DropInfoData_Empty]()
    var conveyor_drops = [DropInfo.DropInfoData_Conveyor]()
    for dropInfo in dropInfos {
        switch dropInfo {
        case .conveyor(let data):
            conveyor_drops.append(data)
        case .empty(let data):
            empty_drops.append(data)
        }
    }
    
    var empty_drops_sum = 0
    for empty_drop in empty_drops {
        empty_drops_sum += (empty_drop.x2 - empty_drop.x1) + 1
    }
    
    let total_drops = (1_000_000 - 0) + 1
    
    return getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                  conveyor_drops: conveyor_drops,
                                                  empty_drops: empty_drops_sum,
                                                  total_drops: total_drops,
                                                  locked_conveyor: locked_conveyor,
                                                  locked_direction: locked_direction)
}
*/

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

// For x from 0 to 1_000_000
// We can use from (x1 + 1)...(x2 - 1) on each conveyor.
// This is where a drop from x lands. The result will perfectly
// connect, for example [(x1: 0, x2: 1), (x1: 2, x2: 999), (x1: 1_000, x2: 1_000_000)]
func getDropInfos(conveyors: [Conveyor]) -> [DropInfo] {
    let max_x = 1_000_000
    let initial_y = 1_000_000
    var result = [DropInfo]()
    var landings = [Conveyor?]()
    for x in 0...max_x {
        landings.append(collide(x: x, y: initial_y, conveyors: conveyors))
    }
    var index = 0
    while index <= max_x {
        let conveyor = landings[index]
        var seek = index + 1
        while seek <= max_x && landings[seek] == conveyor {
            seek += 1
        }
        let x1 = index
        let x2 = seek - 1
        
        if let conveyor = conveyor {
            result.append(.conveyor(.init(x1: x1, x2: x2, conveyor: conveyor)))
        } else {
            result.append(.empty(.init(x1: x1, x2: x2)))
        }
        index = seek
    }
    return result
}

func getMinExpectedHorizontalTravelDistance(_ conveyors: [Conveyor]) -> Float {
    
    for conveyor in conveyors {
        print(conveyor)
    }
    
    for conveyor in conveyors {
        conveyor.left_collider = collide(x: conveyor.x1, y: conveyor.y, conveyors: conveyors)
        conveyor.right_collider = collide(x: conveyor.x2, y: conveyor.y, conveyors: conveyors)
    }
    
    print("There's \(conveyors.count) conveyors.")
    for conveyor in conveyors {
        let left = conveyor.left_collider?.index ?? -1
        let right = conveyor.right_collider?.index ?? -1
        
        print("\tConveyor[\(conveyor.index)] (y = \(conveyor.y)) {\(conveyor.x1) to \(conveyor.x2)} left: \(left), right: \(right)")
        
    }
    
    /*
    let dropInfos = getDropInfos(conveyors: conveyors)
    
    print("There's \(dropInfos.count) drops.")
    for dropInfo in dropInfos {
        switch dropInfo {
        case .empty(let data):
            print("\tDROP(Empty {\(data.x1) to \(data.x2)})")
        case .conveyor(let data):
            print("\tDROP(Conveyor {\(data.x1) to \(data.x2)} on \(data.conveyor))")
        }
    }
    */
    
    let drops = getDrops(conveyors: conveyors)
    
    var result = Double(100_000_000_000_000_000_000_000_000.0)
    
    /*
    for conveyor in conveyors {
        for direction in Direction.allCases {
            let result_for_locked_and_dir = getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                                                   dropInfos: dropInfos,
                                                                                   locked_conveyor: conveyor,
                                                                                   locked_direction: direction)
            print("for locked: \(conveyor) and dir: \(direction), result = \(result_for_locked_and_dir)")
            result = min(result, result_for_locked_and_dir)
        }
    }
    */
    
    
    //You should pick the second conveyor belt and cause it to run to the right.
    //Packages falling at x-coordinates in the intervals (0, 100,000] and (800,000, 1,000,000] will fall directly to the ground
    //packages falling at x-coordinates in the interval (400,000, 800,000) will have an average horizontal travel distance of 200,000 units.
    
    //[y] packages falling at x-coordinates in the interval (100,000, 400,000] {{ 100001 to 400000 }}
    //which will have an average horizontal travel distance of
    //    150,000 units (if the first conveyor belt runs to the left)
    //    350,000 units (if it runs to the right).
    
    //This yields an overall expected horizontal travel distance of 0 * 0.3 +
    //200,000 * 0.4 + ((150,000 + 350,000)/2) * 0.3 = 155,000, which is the minimum achievable
    //expected horizontal travel distance.
    
    /*
    var result_for_locked_and_dir = getMinExpectedHorizontalTravelDistance(conveyors: conveyors,
                                                                           dropInfos: dropInfos,
                                                                           locked_conveyor: conveyors[1],
                                                                           locked_direction: .right)
    print("for locked: 1_LOCKED and dir: LEFT, result = \(result_for_locked_and_dir)")
    result = min(result, result_for_locked_and_dir)
    */
    
    return Float(result)
    
}

func getMinExpectedHorizontalTravelDistance(_ testCase: TestCase) -> Float {
    getMinExpectedHorizontalTravelDistance(testCase.conveyors)
}

func getMinExpectedHorizontalTravelDistance(_ N: Int, _ H: [Int], _ A: [Int], _ B: [Int]) -> Float {
    // Write your code here
    
    
    
    let max_x = 1_000_000
    
    var conveyors = [Conveyor]()
    for index in 0..<N {
        let y = H[index]
        let x1 = A[index]
        let x2 = B[index]
        let conveyor = Conveyor(name: "c\(index)", index: index, x1: x1, x2: x2, y: y)
        conveyors.append(conveyor)
    }
    
    return getMinExpectedHorizontalTravelDistance(conveyors)
    
}
