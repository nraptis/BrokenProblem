//
//  Interval.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/18/25.
//

import Foundation

struct Interval {
    enum BookEnd {
        case closed(Int)
        case open(Int)
    }
    let start: BookEnd
    let end: BookEnd
}
