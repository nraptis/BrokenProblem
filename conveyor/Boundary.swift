//
//  Boundary.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

enum Boundary: Equatable {
    case closed(Int)
    case open(Int)
    static func == (lhs: Boundary, rhs: Boundary) -> Bool {
        switch (lhs, rhs) {
        case (.closed(let l), .closed(let r)):
            return l == r
        case (.open(let l), .open(let r)):
            return l == r
        default:
            return false
        }
    }
}
