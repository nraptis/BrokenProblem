//
//  Conveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class Conveyor: Hashable, CustomStringConvertible {
    
    let name: String
    let index: Int
    
    var heapIndex = 0
    
    let y: Int
    let x1: Int
    let x2: Int
    
    var left_collider: Conveyor?
    var right_collider: Conveyor?
    
    init(name: String, index: Int, x1: Int, x2: Int, y: Int) {
        let _x1 = min(x1, x2)
        let _x2 = max(x1, x2)
        self.name = name;self.index = index;self.y = y;self.x1 = _x1; self.x2 = _x2
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
    
    static func ==(lhs: Conveyor, rhs: Conveyor) -> Bool {
        lhs.index == rhs.index
    }
    
    // A package can be considered to occupy a single point on the plane. If a package lands strictly
    // within conveyor belt i (excluding its endpoints), then it will be transported to its left or right end
    func between(x: Int) -> Bool {
        if x > x1 && x < x2 {
            return true
        } else {
            return false
        }
    }
    
    func below(y: Int) -> Bool {
        if y > self.y {
            return true
        } else {
            return false
        }
    }

    func average_all_smart(x1: Int, x2: Int, direction: Direction) -> Double {
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        
        let count = right_x - left_x + 1
        if count <= 0 { return 0.0 }
        
        switch direction {
        case .left:
            // summing (x - x1) from x in [left_x...right_x]
            let first = left_x - self.x1
            let last = right_x - self.x1
            let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
            return Double(sum) / Double(count)
            
        case .right:
            // summing (x2 - x) from x in [left_x...right_x]
            let first = self.x2 - right_x
            let last = self.x2 - left_x
            let sum = (last * (last + 1)) / 2 - ((first - 1) * first) / 2
            return Double(sum) / Double(count)
        }
    }

    func average_right(_ dropInfo: DropInfo.DropInfoData_Conveyor) -> Double {
        
        if dropInfo.x1 == dropInfo.x2 {
            // This is definitely right, as proven through observation.
            // In this case, it's a one-point drop, there is no interval.
            return Double(x2 - dropInfo.x1)
        }
        
        if dropInfo.x1 == (x1 + 1) {
            if dropInfo.x2 == (x2 - 1) {
                // This is definitely right, as illustrated by example #1
                return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .right)
                // This is also right, as observed
                // return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2 + 1, direction: .right)
                
            } else {
                // This is definitely right, as illustrated by example #1
                // This is correct for the case (100_000, 400_000]
                // Therefore, it seems to be correct this type of case.
                return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2, direction: .right)
            }
        } else if dropInfo.x2 == (x2 - 1) {
            // This seems correct, as illustrated by this example:
            //DropInfo => Conveyor [100001, 599999] @ 0 C[100000, 600000]
            //DropInfo => Conveyor [600000, 799999] @ 1 C[400000, 800000]
            return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2 + 1, direction: .right)
        } else {
            // This is definitely right, as illustrated by the (x1, x2) = (x1 - 1, x2 + 2) examples.
            return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .right)
        }
    }

    func average_left(_ dropInfo: DropInfo.DropInfoData_Conveyor) -> Double {
        
        if dropInfo.x1 == dropInfo.x2 {
            // This is definitely right, as proven through observation.
            // In this case, it's a one-point drop, there is no interval.
            return Double(dropInfo.x1 - x1)
        }
        
        if dropInfo.x1 == (x1 + 1) {
            if dropInfo.x2 == (x2 - 1) {
                // This is definitely right, as illustrated by example #1
                return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .left)
                // This is also right, as observed
                //return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2 + 1, direction: .left)
            } else {
                // This is definitely right, as illustrated by example #1
                // This is correct for the case (100_000, 400_000]
                // Therefore, it seems to be correct this type of case.
                return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2, direction: .left)
            }
        } else if dropInfo.x2 == (x2 - 1) {
            // This seems correct, as illustrated by this example:
            //DropInfo => Conveyor [100001, 599999] @ 0 C[100000, 600000]
            //DropInfo => Conveyor [600000, 799999] @ 1 C[400000, 800000]
            return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2 + 1, direction: .left)
        } else {
            // This is definitely right, as illustrated by the (x1, x2) = (x1 - 1, x2 + 2) examples.
            return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .left)
        }
    }
    
    func count(_ dropInfo: DropInfo.DropInfoData_Conveyor) -> Int {
        
        if dropInfo.x1 == dropInfo.x2 {
            // In this case, it's a one-point drop, there is no interval.
            return 1
        }
        
        if dropInfo.x1 == (x1 + 1) {
            if dropInfo.x2 == (x2 - 1) {
                return (dropInfo.x2 - dropInfo.x1) + 1
                
            } else {
                return (dropInfo.x2 - dropInfo.x1) + 1
            }
        } else if dropInfo.x2 == (x2 - 1) {
            return (dropInfo.x2 - dropInfo.x1) + 1
        } else {
            return (dropInfo.x2 - dropInfo.x1) + 1
        }
    }
    
    var description: String {
        return "{\(name), [\(x1) to \(x2), y=\(y)]}"
    }
    
}
