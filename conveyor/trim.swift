//
//  trim.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/26/25.
//

import Foundation

func trim(d: Double) -> String {
    let s = String(d)
    let halves = s.split(separator: ".")
    
    if halves.isEmpty {
        return "0"
    }
    if halves.count == 1 {
        return addCommas(to: String(halves[0]))
    }
    
    let whole = String(halves[0])
    var fraction = String(halves[1])
    
    // 1.) remove trailing zeroes from fraction
    while fraction.last == "0" {
        fraction.removeLast()
    }
    
    // 2.) add , for every 3 digits in whole
    let formattedWhole = addCommas(to: whole)
    
    // 3.) if fraction is empty, return whole
    if fraction.isEmpty {
        return formattedWhole
    }
    
    // 4.) if fraction not empty, return whole.fraction
    return "\(formattedWhole).\(fraction)"
}

private func addCommas(to number: String) -> String {
    var chars = Array(number)
    var result = ""
    var count = 0
    var isNegative = false
    
    if chars.first == "-" {
        isNegative = true
        chars.removeFirst()
    }
    
    for char in chars.reversed() {
        if count > 0 && count % 3 == 0 {
            result = "," + result
        }
        result = String(char) + result
        count += 1
    }
    
    if isNegative {
        result = "-" + result
    }
    
    return result
}
