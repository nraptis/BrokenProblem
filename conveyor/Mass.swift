//
//  Mass.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/25/25.
//

import Foundation

class BlackHole {
    let center: Double
    let mass: Double
    init(center: Double, mass: Double) {
        if mass <= 0.0 {
            fatalError("A black hole cannot have a mass less than or equal to zero.")
        }
        self.center = center
        self.mass = mass
    }
}
