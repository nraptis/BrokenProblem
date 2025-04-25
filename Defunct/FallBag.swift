//
//  FallBag.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/23/25.
//

import Foundation

class FallBag {
    
    class Node {
        let x: Int
        var weight = Double(0.0)
        
        init(x: Int) {
            self.x = x
        }
        
        func record(weight: Double) {
            self.weight += weight
        }
    }
    
    var table = [Int: Node]()
    var list = [Node]()
    
    func record(x: Int, weight: Double) {
        if let node = table[x] {
            node.record(weight: weight)
        } else {
            let node = Node(x: x)
            node.record(weight: weight)
            table[x] = node
            list.append(node)
        }
    }
    
    func printme(name: String) {
        print("FallBag(\(name)) {")
        
        var list = list.sorted { $0.x < $1.x }
        for node in list {
            print("\tNode(x: \(node.x), weight: \(node.weight)")
        }
        print("} (End FallBag(\(name)))")
        
    }
    
}
