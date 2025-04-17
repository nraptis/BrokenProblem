//
//  Conveyor.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/17/25.
//

import Foundation

class Conveyor: Hashable {
    let index: Int
    let y: Int
    let x1: Int
    let x2: Int
    let length: Int
    
    var left_collider: Conveyor?
    var right_collider: Conveyor?
    
    init(index: Int, x1: Int, x2: Int, y: Int) {
        let _x1 = min(x1, x2)
        let _x2 = max(x1, x2)
        self.index = index;self.y = y;self.x1 = _x1; self.x2 = _x2; length = (_x2 - _x1)
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
    
    func movement_right(x: Int) -> Int {
        return x2 - x
    }
    
    func movement_left(x: Int) -> Int {
        return x - x1
    }
    
    func sum_all_smart(x: Int, direction: Direction) -> Int {
        var result = 0
        switch direction {
        case .left:
            if x > self.x1 {
                let range = (x - self.x1)
                result = (range * (range + 1)) / 2
            }
        case .right:
            if x < self.x2 {
                let range = (self.x2 - x)
                result = (range * (range + 1)) / 2
            }
        }
        return result
    }

    func sum_all_brute(x: Int, direction: Direction) -> Int {
        var result = 0
        switch direction {
        case .left:
            var start = x
            while start >= self.x1 {
                result += (start - self.x1)
                start -= 1
            }
            return result
        case .right:
            var start = x
            while start <= self.x2 {
                result += (self.x2 - start)
                start += 1
            }
            return result
        }
    }

    func sum_all_brute(x1: Int, x2: Int, direction: Direction) -> Int {
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        
        var result = 0
        switch direction {
        case .left:
            var start = right_x
            while start >= left_x {
                result += (start - self.x1)
                start -= 1
            }
            return result
        case .right:
            var start = left_x
            while start <= right_x {
                result += (self.x2 - start)
                start += 1
            }
            return result
        }
    }

    func sum_all_smart(x1: Int, x2: Int, direction: Direction) -> Int {
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        
        let count = right_x - left_x + 1
        if count <= 0 { return 0 }
        
        switch direction {
        case .left:
            // sum of (x - x1) for x in [left_x, right_x]
            let first = left_x - self.x1
            let last = right_x - self.x1
            return (last * (last + 1)) / 2 - ((first - 1) * first) / 2
            
        case .right:
            // sum of (x2 - x) for x in [left_x, right_x]
            let first = self.x2 - right_x
            let last = self.x2 - left_x
            return (last * (last + 1)) / 2 - ((first - 1) * first) / 2
        }
    }

    func average_all_smart(x: Int, direction: Direction) -> Double {
        switch direction {
        case .left:
            if x > x1 {
                return Double(x - self.x1) / 2.0
            }
        case .right:
            if x < x2 {
                return Double(self.x2 - x) / 2.0
            }
        }
        return 0.0
    }

    func average_all_brute(x: Int, direction: Direction) -> Double {
        switch direction {
        case .left:
            var start = x
            var count = 0
            var sum = 0
            while start >= self.x1 {
                sum += (start - self.x1)
                start -= 1
                count += 1
            }
            if count > 0 {
                return Double(sum) / Double(count)
            } else {
                return 0.0
            }
        case .right:
            var start = x
            var count = 0
            var sum = 0
            while start <= self.x2 {
                sum += (self.x2 - start)
                start += 1
                count += 1
            }
            if count > 0 {
                return Double(sum) / Double(count)
            } else {
                return 0.0
            }
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

    func average_all_brute(x1: Int, x2: Int, direction: Direction) -> Double {
        
        var right_x = max(x1, x2)
        right_x = max(right_x, self.x1)
        right_x = min(right_x, self.x2)
        
        var left_x = min(x1, x2)
        left_x = min(left_x, self.x2)
        left_x = max(left_x, self.x1)
        
        switch direction {
        case .left:
            var start = right_x
            var count = 0
            var sum = 0
            
            while start >= left_x {
                sum += (start - self.x1)
                start -= 1
                count += 1
            }
            if count > 0 {
                return Double(sum) / Double(count)
            } else {
                return 0.0
            }
        case .right:
            var start = left_x
            var count = 0
            var sum = 0
            
            while start <= right_x {
                sum += (self.x2 - start)
                start += 1
                count += 1
            }
            if count > 0 {
                return Double(sum) / Double(count)
            } else {
                return 0.0
            }
        }
    }
    
    func average_right(_ dropInfo: DropInfo.DropInfoData_Conveyor) -> Double {
        
        //return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .right)
        
        if dropInfo.x1 == (x1 + 1) {
            if dropInfo.x2 == (x2 - 1) {
                return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .right)
            } else {
                return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2, direction: .right)
            }
        } else if dropInfo.x2 == (x2 - 1) {
            return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2 + 1, direction: .right)
        } else {
            return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2 + 1, direction: .right)
        }
    }

    func average_left(_ dropInfo: DropInfo.DropInfoData_Conveyor) -> Double {
        
        //return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .left)
        
        if dropInfo.x1 == (x1 + 1) {
            if dropInfo.x2 == (x2 - 1) {
                return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2, direction: .left)
            } else {
                return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2, direction: .left)
            }
        } else if dropInfo.x2 == (x2 - 1) {
            return average_all_smart(x1: dropInfo.x1, x2: dropInfo.x2 + 1, direction: .left)
        } else {
            return average_all_smart(x1: dropInfo.x1 - 1, x2: dropInfo.x2 + 1, direction: .left)
        }
    }
    
}
