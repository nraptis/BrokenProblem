//
//  Test_Case_Explorer.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/18/25.
//

import Foundation

class Test_Case_Explorer {
    
    static func test(_ testCase: TestCase) {
    
        let dropInfos = getDropInfos(conveyors: testCase.conveyors)
        
        for dropInfo in dropInfos {
            print(dropInfo)
        }
        
        for dropInfo in dropInfos {
            switch dropInfo {
            case .empty(let dropInfoData_Empty):
                break
            case .conveyor(let dropInfoData):
                let conveyor = dropInfoData.conveyor
                let m_left = conveyor.average_left(dropInfoData)
                let m_right = conveyor.average_right(dropInfoData)
                print("For conveyor [\(conveyor.index)] => m_left: \(m_left), m_right: \(m_right)")
            }
        }
    }
    
    
    
}
