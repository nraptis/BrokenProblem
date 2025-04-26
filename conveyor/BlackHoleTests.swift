//
//  BlackHoleTests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/25/25.
//

import Foundation

class BlackHoleTests {
    
    private func get_black_holes(conveyors: [Conveyor]) -> [Int: [BlackHole]] {
        
        var result = [Int: [BlackHole]]()
        findBlackHoles(conveyors: conveyors)
        
        for conveyor in conveyors {
            var black_holes = [BlackHole]()

            if result[conveyor.index] != nil {
                fatalError("Why are there 2 conveyors with same index?")
            }
            result[conveyor.index] = black_holes
        }
        return result
    }
    
    func test_black_hole_one_drop() {
        
    }
    
    
}
