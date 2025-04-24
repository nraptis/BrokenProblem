//
//  Split.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

func combine_duplicates(datums: [EdgeInfoDatum]) -> [EdgeInfoDatum] {
    struct MergeKey: Hashable {
        let distance: Int
        let divided: Int
    }

    var counter = [MergeKey: Int]()
    for datum in datums {
        let key = MergeKey(distance: datum.distance, divided: datum.divided)
        counter[key, default: 0] += 1
    }

    var keys = counter.keys.sorted {
        $0.distance != $1.distance ? $0.distance < $1.distance : $0.divided > $1.divided
    }

    var i = 0
    while i < keys.count {
        let key = keys[i]
        i += 1

        guard let count = counter[key], count >= 2, key.divided > 1 else { continue }

        let pairs = count / 2
        let leftover = count % 2
        counter[key] = leftover

        let mergedKey = MergeKey(distance: key.distance, divided: key.divided / 2)
        counter[mergedKey, default: 0] += pairs

        // Only reprocess mergedKey if it's newly created or could be merged again
        if !(counter[mergedKey] != nil) || counter[mergedKey]! >= 2 {
            keys.append(mergedKey)
        }
    }

    var result = [EdgeInfoDatum]()
    for (key, count) in counter {
        for _ in 0..<count {
            result.append(EdgeInfoDatum(distance: key.distance, divided: key.divided))
        }
    }

    return result
}

struct EdgeInfoDatum: Hashable {
    let distance: Int
    let divided: Int
}

enum EdgeInfoSide: CustomStringConvertible {
    case none
    case some([EdgeInfoDatum])
    
    var description: String {
        switch self {
        case .none:
            return "\t\tNULL"
        case .some(let datums):
            var list = "\t\t[\n"
            for item in datums {
                let percent = Double(100.0) / Double(item.divided)
                list += "\t\t\t{percent: \(percent)% fraction: (1 / \(item.divided)) distance: \(item.distance)}\n"
            }
            list += "\t\t]\n"
            return list
        }
    }
    
}

class EdgeInfo: CustomStringConvertible {
    var left = EdgeInfoSide.none
    var right = EdgeInfoSide.none
    init() { }
    
    var description: String {
        var result = "EdgeInfo: {\n"
        result += "\tLeft => \n"
        result += "\(left)\n"
        result += "\tRight => \n"
        result += "\(right)\n"
        result += "}\n"
        return result
    }
}

func calculateEdgeInfo(conveyors: [Conveyor]) {
    
    
    
    // We go from the bottom-up...
    let conveyors = conveyors.sorted { $0.y < $1.y }
    
    for conveyor in conveyors {
        
        
        if let left_collider = conveyor.left_collider {
            
            let distance_left = conveyor.x1 - left_collider.x1
            let distance_right = left_collider.x2 - conveyor.x1
            
            var left = [EdgeInfoDatum]()
            switch left_collider.edge.left {
            case .none:
                let datum = EdgeInfoDatum(distance: distance_left, divided: 2)
                left.append(datum)
            case .some(let datums):
                for original_datum in datums {
                    let distance = original_datum.distance + distance_left
                    let divided = original_datum.divided * 2
                    let datum = EdgeInfoDatum(distance: distance, divided: divided)
                    left.append(datum)
                }
            }
            switch left_collider.edge.right {
            case .none:
                let datum = EdgeInfoDatum(distance: distance_right, divided: 2)
                left.append(datum)
            case .some(let datums):
                for original_datum in datums {
                    let distance = original_datum.distance + distance_right
                    let divided = original_datum.divided * 2
                    let datum = EdgeInfoDatum(distance: distance, divided: divided)
                    left.append(datum)
                }
            }
            
            if left.count <= 0 {
                fatalError("This should not be possible, a count of 0.")
            }
            
            left = combine_duplicates(datums: left)
            
            if left.count <= 0 {
                fatalError("This should not be possible, a count of 0.")
            }
            
            conveyor.edge.left = .some(left)
            
            
        } else {
            conveyor.edge.left = .none
        }
        
        if let right_collider = conveyor.right_collider {
            
            
            let distance_left = conveyor.x2 - right_collider.x1
            let distance_right = right_collider.x2 - conveyor.x2
            
            var right = [EdgeInfoDatum]()
            switch right_collider.edge.left {
            case .none:
                let datum = EdgeInfoDatum(distance: distance_left, divided: 2)
                right.append(datum)
            case .some(let datums):
                for original_datum in datums {
                    let distance = original_datum.distance + distance_left
                    let divided = original_datum.divided * 2
                    let datum = EdgeInfoDatum(distance: distance, divided: divided)
                    right.append(datum)
                }
            }
            switch right_collider.edge.right {
            case .none:
                let datum = EdgeInfoDatum(distance: distance_right, divided: 2)
                right.append(datum)
            case .some(let datums):
                for original_datum in datums {
                    let distance = original_datum.distance + distance_right
                    let divided = original_datum.divided * 2
                    let datum = EdgeInfoDatum(distance: distance, divided: divided)
                    right.append(datum)
                }
            }
            
            if right.count <= 0 {
                fatalError("This should not be possible, a count of 0.")
            }
            
            right = combine_duplicates(datums: right)
            
            if right.count <= 0 {
                fatalError("This should not be possible, a count of 0.")
            }
            
            conveyor.edge.right = .some(right)
            
        } else {
            conveyor.edge.right = .none
        }
    }
    
    
}
