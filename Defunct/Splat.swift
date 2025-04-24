//
//  Splat.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

class Splat {
    let length: Int
    var count: Int
    init(length: Int, count: Int) {
        self.length = length
        self.count = count
    }
}

class SplatGroup {
    // Length: Splat
    // But this length is the local conveyor's length.
    var dict = [Int: Splat]()
    
    init() {
        
    }
    
    func add(length_end: Int, count: Int) {
        if let splat = dict[length_end] {
            splat.count += count
        } else {
            dict[length_end] = Splat(length: length_end, count: count)
        }
    }
}

class SplatPiece {
    
    // Length: Splat
    // But this length is the local conveyor's length.
    var dict = [Int: SplatGroup]()
    let conveyor: Conveyor
    
    init(conveyor: Conveyor) {
        self.conveyor = conveyor
    }
    
    func add(conveyor: Conveyor, length_local: Int, length_end: Int, count: Int) {
        
        if let group = dict[length_local] {
            group.add(length_end: length_end, count: count)
        } else {
            let group = SplatGroup()
            group.add(length_end: length_end, count: count)
            dict[length_local] = group
        }
    }
}

class SplatInfo {
    
    // Length: Splat
    // But this length is the local conveyor's length.
    var dict = [Conveyor: SplatPiece]()
    
    init() {
        
    }
    
    func add(conveyor: Conveyor, length_local: Int, length_end: Int, count: Int) {
        
        if let piece = dict[conveyor] {
            piece.add(conveyor: conveyor,
                      length_local: length_local,
                      length_end: length_end,
                      count: count)
        } else {
            let piece = SplatPiece(conveyor: conveyor)
            piece.add(conveyor: conveyor,
                      length_local: length_local,
                      length_end: length_end,
                      count: count)
            dict[conveyor] = piece
        }
    }
}
