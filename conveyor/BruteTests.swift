//
//  BruteTests.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/24/25.
//

import Foundation

struct BruteTests {
    
    static func execute(name: String, conveyors: [Conveyor]) -> Bool {
        
        let conveyors1 = Conveyor.clone(conveyors: conveyors)
        let conveyors2 = Conveyor.clone(conveyors: conveyors)
        let conveyors3 = Conveyor.clone(conveyors: conveyors)
        
        let sol1 = getMinExpectedHorizontalTravelDistance(conveyors: conveyors1)
        let sol2 = getMinExpectedHorizontalTravelDistance_BruteForce(conveyors: conveyors2)
        let sol3 = getMinExpectedHorizontalTravelDistance_Simulation(conveyors: conveyors3)
        
        
        let delta1 = fabs(sol1 - sol2)
        let delta2 = fabs(sol1 - sol3)
        let delta3 = fabs(sol2 - sol3)
        
        let epsilon = 0.005
        
        if (delta1 > epsilon) || (delta2 > epsilon) || (delta3 > epsilon) {
            print("\(name) Failed!!!")
            
            print("c_lock_simulation = \(c_lock_simulation), \(d_lock_simulation)")
            print("result_simulation = \(sol3)")
            
            print("c_lock_wise = \(c_lock_wise), \(d_lock_wise)")
            print("result_wise = \(sol1)")
            
            
            for conveyor in conveyors {
                print("\t\(conveyor)")
            }
            print("End-Conveyor-List")
            
            return false
        } else {
            
            print("\(name) Passed!!!")
            
            /*
            
            
            print("sol1 = \(sol1)")
            print("sol2 = \(sol2)")
            print("sol3 = \(sol3)")
            
            print("c_lock_simulation = \(c_lock_simulation)")
            print("d_lock_simulation = \(d_lock_simulation)")
            
            print("c_lock_brute = \(c_lock_brute)")
            print("d_lock_brute = \(d_lock_brute)")
            
            print("c_lock_wise = \(c_lock_wise)")
            print("d_lock_wise = \(d_lock_wise)")
            */
            
            return true
        }
    }
    
    static func test_all() {
        test_discovered_failure_case_a()
        test_discovered_failure_case_b()
        test_discovered_failure_case_c()
        test_discovered_failure_case_d()
        test_discovered_failure_case_e()
        test_discovered_failure_case_f()
        test_discovered_failure_case_g()
        test_discovered_failure_case_h()
        test_discovered_failure_case_i()
        test_discovered_failure_case_j()
        test_discovered_failure_case_k()
        test_discovered_failure_case_l()
        test_discovered_failure_case_m()
        test_discovered_failure_case_n()
        test_discovered_failure_case_o()
        test_discovered_failure_case_p()
        test_discovered_failure_case_q()
        test_discovered_failure_case_r()
        test_discovered_failure_case_s()
        test_discovered_failure_case_t()
        test_discovered_failure_case_u()
    }
    
    static func test_discovered_failure_case_a() {
        let c_0 = Conveyor(name: "c0", index: 0, x1: 400000, x2: 900000, y: 40)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 300000, x2: 800000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_a", conveyors: conveyors)
    }

    static func test_discovered_failure_case_b() {
        let c_0 = Conveyor(name: "c0", index: 0, x1: 100000, x2: 700000, y: 10)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 200000, x2: 800000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_b", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_c() {

        //              [            c2            ]
        //          [          c0          ]
        //      [              c1                  ] ( ==> )
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(name: "c0", index: 0, x1: 200000, x2: 800000, y: 50)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 100000, x2: 1000000, y: 40)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 300000, x2: 1000000, y: 70)
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_c", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_d() {
        //                          [  c1  ] ( ==> )
        //                      [    c0    ]
        //          [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: {c1, right}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 500000, x2: 800000, y: 70)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 600000, x2: 800000, y: 100)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 200000, x2: 600000, y: 0)
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_d", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_e() {
        
        //  [        c0         ]
        //              [          c1          ] ( <== )
        //      [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 0, x2: 500000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 300000, x2: 900000, y: 70)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 100000, x2: 500000, y: 40)
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_e", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_f() {
        
        //              [       c0     ]  ( ==> )
        //  [           c1         ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c0, right}
        let c_0 = Conveyor(name: "c0", index: 1, x1: 300_000, x2: 700_000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 0, x1: 0, x2: 600_000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_f", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_g() {
        
        //              [            c0            ]  ( ==> )
        //  [              c1              ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: {c0, right}
        let c_0 = Conveyor(name: "c0", index: 1, x1: 300000, x2: 1000000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 0, x1: 0, x2: 800000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_g", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_h() {
        
        //              [            c0        ]  ( ==> )
        //  [              c1              ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: {c0, right}
        let c_0 = Conveyor(name: "c0", index: 1, x1: 300_000, x2: 900_000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 0, x1: 0, x2: 800_000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_h", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_i() {
        
        //              [            c0        ]  ( ==> )
        //          [           c1         ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c0, right}
        let c_0 = Conveyor(name: "c0", index: 1, x1: 300_000, x2: 900_000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 0, x1: 200_000, x2: 800_000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_i", conveyors: conveyors)
    }
    
    
    static func test_discovered_failure_case_j() {
        
        //                  [    c0    ]
        //  [          c1          ]
        //      [              c2              ]  ( ==> )
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c2, right}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 400000, x2: 700000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 0, x2: 600000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 100000, x2: 900000, y: 0)
        
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_j", conveyors: conveyors)
    }
    
    
    static func test_discovered_failure_case_k() {
        
        //              [            c0            ]
        //          [           c1         ]           ( ==> )
        //      [                 c2               ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, right}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 300000, x2: 1000000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 200000, x2: 800000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 100000, x2: 1000000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_k", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_l() {
        
        //      [          c0          ]
        //                      [        c1        ]           ( <== )
        //                  [    c2    ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        
        
        //      [          c0          ]
        //      @@ drop at [100000 to 700000], left cost = 300000.0, right cost = 300000.0
        //      c0 The full costs: left 300000.0, right 625000.0, average 462500.0
        //
        //                      [        c1        ]           ( <== )
        //                      @@ drop at [700000 to 1000000], left cost = 350000.0, right cost = 150000.0
        //                      @@ fall at 700000, amt 150000
        //                      c1 The full costs: left 850000.0, right 600000.0, average 725000.0
        //
        //                  [    c2    ]
        //                  @@ fall at 500000, amt 350000
        //                      Component from fall: 150_000 + 200_000
        //                      Componnt from drop: 350_000
        //                      ((Component from fall) + (Component from drop)) / 2 = 350_000
        //                  c2 The full costs: left 450000.0, right 550000.0, average 500000.0
        //
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 100000, x2: 700000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 500000, x2: 1000000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 400000, x2: 700000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_l", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_m() {
        //      [            c0            ]
        //                  [          c1          ]           ( <== )
        //          [           c2         ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 100000, x2: 800000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 400000, x2: 1000000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 200000, x2: 800000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_m", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_n() {
        //          [          c0          ]
        //                  [          c1          ]           ( <== )
        //          [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 200000, x2: 800000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 400000, x2: 1000000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 200000, x2: 600000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_n", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_o() {
        
        //      [          c0          ]
        //                      [        c1        ]           ( <== )
        //                  [    c2    ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 100000, x2: 700000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 500000, x2: 1000000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 400000, x2: 700000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_o", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_p() {
        
        //          [          c0          ]
        //                      [        c1        ]           ( <== )
        //                  [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 200000, x2: 800000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 500000, x2: 1000000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 400000, x2: 800000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_p", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_q() {
        let c_0 = Conveyor(name: "c0", index: 0, x1: 300000, x2: 500000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 200000, x2: 400000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_q", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_r() {
        
        //  [        c1        ]   ( <== )
        //  @@ drop at [0 to 500000], left cost = 250000.0, right cost = 250000.0
        //
        //          [          c0          ]
        //          @@ drop at [500000 to 800000], left cost = 450000.0, right cost = 150000.0
        //          @@ fall at 500000, amt 125000.0, left_d = 300000, right_d = 300000

        //Expectation: {c1, left}
        let c_1 = Conveyor(name: "c1", index: 1, x1: 0, x2: 500000, y: 100)
        let c_0 = Conveyor(name: "c0", index: 0, x1: 200000, x2: 800000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_r", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_s() {
        
        //  [        c0        ]
        //          [          c1          ]        ( ==> )
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 0, x2: 500000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 200000, x2: 800000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_s", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_t() {
        
        //          [        c0        ]     ( ==> )
        //          @@ drop at [200000 to 700000], left cost = 250000.0, right cost = 250000.0
        //
        //      [      c1      ]
        //      @@ drop at [100000 to 200000], left cost = 50_000.0, right cost = 350_000.0
        //      @@ fall at 200000, amt 125000.0, left_d = 100000, right_d = 300000
        
        
        // If we set c0 to the right, these are the improvements:
        
        // We subtract out (125_000 + (200_000 / 2)) going left
        // We add 125_000 going right

        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, right}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 200_000, x2: 700_000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 100_000, x2: 500_000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_t", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_u() {
        let c_0 = Conveyor(name: "c0", index: 0, x1: 100000, x2: 900000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 000_000, x2: 700000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_u", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_v() {
        
        //
        //      [            c1            ]   ( ==> )
        //      @@ drop at [100000 to 800000], left cost = 350000.0, right cost = 350000.0
        //
        //  [           c0             ]
        //  @@ drop at [0 to 100000], left cost = 50000.0, right cost = 650000.0
        //  @@ fall at 100000, amt 175000.0, left_d = 100000, right_d = 600000
        //
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        // The improvements if we set c1 to the right:
        // A drop of (350_000) / 2 = 175_000 no longer falls to c0
        // The drop would also travel and additional (100_000 + 600_000) / 2 units

        //Expectation: {c1, right}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 0, x2: 700000, y: 20)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 100000, x2: 800000, y: 80)
        let conveyors = [c_1, c_0]
        _ = execute(name: "test_discovered_failure_case_v", conveyors: conveyors)
    }
    
    
    static func test_discovered_failure_case_w() {
        
        //
        //          [        c0        ]
        //
        //
        //                  [         c1       ] (  ==> ))
        //
        //
        //              [         c2       ]
        
        //
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        // The improvements if we set c1 to the right:
        // A drop of (350_000) / 2 = 175_000 no longer falls to c0
        // The drop would also travel and additional (100_000 + 600_000) / 2 units

        //Expectation: {c1, right}
        let c_0 = Conveyor(name: "c0", index: 0, x1: 200000, x2: 700000, y: 100)
        let c_1 = Conveyor(name: "c1", index: 1, x1: 400000, x2: 900000, y: 50)
        let c_2 = Conveyor(name: "c2", index: 2, x1: 300000, x2: 800000, y: 0)
        
        let conveyors = [c_1, c_0, c_2]
        _ = execute(name: "test_discovered_failure_case_w", conveyors: conveyors)
    }
    
    
    static func test_1000_2_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 2, max_count: 2)
            if execute(name: "test_1000_two_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_two_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_3_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 3, max_count: 3)
            if execute(name: "test_1000_3_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_3_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_4_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 4, max_count: 4)
            if execute(name: "test_1000_4_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_4_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_100_twenty_conveyor() {
        for test_index in 0..<100 {
            let conveyors = GENERATE(min_count: 1, max_count: 20)
            execute(name: "test_100_twenty_conveyor_\(test_index)", conveyors: conveyors)
        }
        print("test_100_twenty_conveyor => Done!")
    }
    
    static func GENERATE(min_count: Int, max_count: Int, tries: Int = 256) -> [Conveyor] {
        
        let count = Int.random(in: min(max_count, min_count)...max(max_count, min_count))
        
        let xs = [0, 100_000, 200_000, 300_000, 400_000, 500_000, 600_000, 700_000, 800_000, 900_000, 1_000_000]
        let ys = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        
        var result = [Conveyor]()
        var tryIndex = 0
        var conveyorIndex = 0
        while result.count < count && tryIndex < tries {
            
            let x1 = xs.randomElement()!
            let x2 = xs.randomElement()!
            let y = ys.randomElement()!
            if x2 > x1 {
                var overlaps = false
                for conveyor in result {
                    if conveyor.y == y {
                        if x1 >= conveyor.x1 && x1 <= conveyor.x2 {
                            overlaps = true
                            break
                        }
                        if x2 >= conveyor.x1 && x2 <= conveyor.x2 {
                            overlaps = true
                            break
                        }
                        if conveyor.x1 >= x1 && conveyor.x1 <= x2 {
                            overlaps = true
                            break
                        }
                        if conveyor.x2 >= x1 && conveyor.x2 <= x2 {
                            overlaps = true
                            break
                        }
                        
                    }
                }
                
                if overlaps == false {
                    let c = Conveyor(name: "c_\(conveyorIndex)", index: conveyorIndex, x1: x1, x2: x2, y: y)
                    result.append(c)
                    conveyorIndex += 1
                }
                
                
            }
            
            tryIndex += 1
        }
        
        return result
    }
    
}
