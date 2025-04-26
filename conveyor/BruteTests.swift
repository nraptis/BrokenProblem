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
            print("~~~~~~~~~~~~~~~~")
            print("~~~~~~~~~~~~~~~~")
            print("\(name) Failed!!!")
            print("========")
            //print("EXPECTED, A = \(c_lock_simulation.name), \(d_lock_simulation), \(sol3)")
            //print("EXPECTED, B = \(c_lock_brute.name), \(d_lock_brute), \(sol2)")
            print("========")
            //print("RESULT ====== \(c_lock_wise.name), \(d_lock_wise), \(sol1)")
            print("========")
            
            for conveyor in conveyors {
                print("\t\(conveyor)")
            }
            print("~~~~~~~~~~~~~~~~")
            print("~~~~~~~~~~~~~~~~")
            return false
        } else {
            return true
        }
    }
    
    static func test_all() {
        test_example_1()
        test_example_2()
        
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
        
        test_1000_2_conveyor()
        test_1000_3_conveyor()
        test_1000_4_conveyor()
        test_1000_5_conveyor()
        test_1000_6_conveyor()
        
        
    }
    
    static func test_example_1() {
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 600000, y: 10)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 800000, y: 20)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_example_1", conveyors: conveyors)
    }
    
    static func test_example_2() {
        let c_0 = Conveyor(index: 0, x1: 5000, x2: 7000, y: 2)
        let c_1 = Conveyor(index: 1, x1: 2000, x2: 8000, y: 8)
        let c_2 = Conveyor(index: 2, x1: 7000, x2: 11000, y: 5)
        let c_3 = Conveyor(index: 3, x1: 9000, x2: 11000, y: 9)
        let c_4 = Conveyor(index: 4, x1: 0, x2: 4000, y: 4)
        let conveyors = [c_0, c_1, c_2, c_3, c_4]
        _ = execute(name: "test_example_2", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_a() {
        
        //
        //              [        c0        ]
        //                  [        c1        ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: (LOCK => c0, DIR => left)
        
        /*
         c0 black holes modified:
             DropBlackHole(x: 550000.0, distance: 250000.0, mass: 250000.0)
         c0 black holes modified:
             DropBlackHole(x: 550000.0, distance: 250000.0, mass: 250000.0)
         c0 black holes modified:
             DropBlackHole(x: 550000.0, distance: 250000.0, mass: 250000.0)
         These is the crush: 125000.0, 168750.0, 187500.0
              ==> left: 125000.0
              ==> right: 168750.0
              ==> random: 187500.0
              ==> improvement_right: 18750.0
              ==> improvement_left: 18750.0
        
        
         c1 black holes modified:
             DropBlackHole(x: 800000.0, distance: 400000.0, mass: 125000.0)
             DropBlackHole(x: 850000.0, distance: 450000.0, mass: 50000.0)
         c1 black holes modified:
             DropBlackHole(x: 800000.0, distance: 100000.0, mass: 125000.0)
             DropBlackHole(x: 850000.0, distance: 50000.0, mass: 50000.0)
         c1 black holes modified:
             DropBlackHole(x: 800000.0, distance: 250000.0, mass: 125000.0)
             DropBlackHole(x: 850000.0, distance: 250000.0, mass: 50000.0)
         These is the crush: 145000.0, 30000.0, 87500.0
              ==> left: 145000.0
              ==> right: 30000.0
              ==> random: 87500.0
              ==> improvement_right: 57500.0
              ==> improvement_left: 57500.0
        */
        
        let c_0 = Conveyor(index: 0, x1: 300000, x2: 800000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 900000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_a", conveyors: conveyors)
    }

    static func test_discovered_failure_case_b() {
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 700000, y: 10)
        let c_1 = Conveyor(index: 1, x1: 200000, x2: 800000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_b", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_c() {

        //              [            c2            ]
        //          [          c0          ]
        //      [              c1                  ] ( ==> )
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(index: 0, x1: 200000, x2: 800000, y: 50)
        let c_1 = Conveyor(index: 1, x1: 100000, x2: 1000000, y: 40)
        let c_2 = Conveyor(index: 2, x1: 300000, x2: 1000000, y: 70)
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_c", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_d() {
        //                          [  c1  ] ( ==> )
        //                      [    c0    ]
        //          [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: {c1, right}
        let c_0 = Conveyor(index: 0, x1: 500000, x2: 800000, y: 70)
        let c_1 = Conveyor(index: 1, x1: 600000, x2: 800000, y: 100)
        let c_2 = Conveyor(index: 2, x1: 200000, x2: 600000, y: 0)
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_d", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_e() {
        
        //  [        c0         ]
        //              [          c1          ] ( <== )
        //      [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(index: 0, x1: 0, x2: 500000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 300000, x2: 900000, y: 70)
        let c_2 = Conveyor(index: 2, x1: 100000, x2: 500000, y: 40)
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_e", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_f() {
        
        //              [       c0     ]  ( ==> )
        //  [           c1         ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c0, right}
        let c_0 = Conveyor(index: 1, x1: 300_000, x2: 700_000, y: 100)
        let c_1 = Conveyor(index: 0, x1: 0, x2: 600_000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_f", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_g() {
        
        //              [            c0            ]  ( ==> )
        //  [              c1              ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: {c0, right}
        let c_0 = Conveyor(index: 1, x1: 300000, x2: 1000000, y: 100)
        let c_1 = Conveyor(index: 0, x1: 0, x2: 800000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_g", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_h() {
        
        //              [            c0        ]  ( ==> )
        //  [              c1              ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        //Expectation: {c0, right}
        let c_0 = Conveyor(index: 1, x1: 300_000, x2: 900_000, y: 100)
        let c_1 = Conveyor(index: 0, x1: 0, x2: 800_000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_h", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_i() {
        
        //              [            c0        ]  ( ==> )
        //          [           c1         ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c0, right}
        let c_0 = Conveyor(index: 1, x1: 300_000, x2: 900_000, y: 100)
        let c_1 = Conveyor(index: 0, x1: 200_000, x2: 800_000, y: 0)
        
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_i", conveyors: conveyors)
    }
    
    
    static func test_discovered_failure_case_j() {
        
        //                  [    c0    ]
        //  [          c1          ]
        //      [              c2              ]  ( ==> )
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c2, right}
        let c_0 = Conveyor(index: 0, x1: 400000, x2: 700000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 0, x2: 600000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 100000, x2: 900000, y: 0)
        
        
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_j", conveyors: conveyors)
    }
    
    
    static func test_discovered_failure_case_k() {
        
        //              [            c0            ]
        //          [           c1         ]           ( ==> )
        //      [                 c2               ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, right}
        let c_0 = Conveyor(index: 0, x1: 300000, x2: 1000000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 200000, x2: 800000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 100000, x2: 1000000, y: 0)
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
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 700000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 500000, x2: 1000000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 400000, x2: 700000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_l", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_m() {
        //      [            c0            ]
        //                  [          c1          ]           ( <== )
        //          [           c2         ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 800000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 1000000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 200000, x2: 800000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_m", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_n() {
        //          [          c0          ]
        //                  [          c1          ]           ( <== )
        //          [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(index: 0, x1: 200000, x2: 800000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 1000000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 200000, x2: 600000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_n", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_o() {
        
        //      [          c0          ]
        //                      [        c1        ]           ( <== )
        //                  [    c2    ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 700000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 500000, x2: 1000000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 400000, x2: 700000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_o", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_p() {
        
        //          [          c0          ]
        //                      [        c1        ]           ( <== )
        //                  [      c2      ]
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(index: 0, x1: 200000, x2: 800000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 500000, x2: 1000000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 400000, x2: 800000, y: 0)
        let conveyors = [c_0, c_1, c_2]
        _ = execute(name: "test_discovered_failure_case_p", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_q() {
        let c_0 = Conveyor(index: 0, x1: 300000, x2: 500000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 200000, x2: 400000, y: 50)
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
        let c_1 = Conveyor(index: 1, x1: 0, x2: 500000, y: 100)
        let c_0 = Conveyor(index: 0, x1: 200000, x2: 800000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_r", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_s() {
        
        //  [        c0        ]
        //          [          c1          ]        ( ==> )
        // 00  01  02  03  04  05  06  07  08  09  10  11  12

        //Expectation: {c1, left}
        let c_0 = Conveyor(index: 0, x1: 0, x2: 500000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 200000, x2: 800000, y: 50)
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
        let c_0 = Conveyor(index: 0, x1: 200_000, x2: 700_000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 100_000, x2: 500_000, y: 50)
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_t", conveyors: conveyors)
    }
    
    //EXPECTED, A = c0, right, 355000.0
    //EXPECTED, B = c0, right, 355000.0
    static func test_discovered_failure_case_u() {
        
        //
        //      [             c0               ] ( ==> )
        //
        //  [            c1            ]
        //
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        
        let c_0 = Conveyor(index: 0, x1: 100_000, x2: 900000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 000_000, x2: 700000, y: 50)
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
        let c_0 = Conveyor(index: 0, x1: 0, x2: 700000, y: 20)
        let c_1 = Conveyor(index: 1, x1: 100000, x2: 800000, y: 80)
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
        let c_0 = Conveyor(index: 0, x1: 200000, x2: 700000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 900000, y: 50)
        let c_2 = Conveyor(index: 2, x1: 300000, x2: 800000, y: 0)
        
        let conveyors = [c_1, c_0, c_2]
        _ = execute(name: "test_discovered_failure_case_w", conveyors: conveyors)
    }
    
    static func test_discovered_failure_case_x() {
        
        
        //
        //                  [          c0          ]
        //
        //  [          c1          ]
        //
        // 00  01  02  03  04  05  06  07  08  09  10  11  12
        //
        
        /*
        Black Hole:{c0, [400000 to 600000, y=100] left: c1}, 1 Mixed Holes
            ORIGINALS ======>
                DropBlackHole(x:500,000, d:0, m:100,000, s: DROP(400000, 600000))
        Black Hole:{c1, [0 to 600000, y=50]}, 2 Mixed Holes
            ORIGINALS ======>
                DropBlackHole(x:200,000, d:0, m:200,000, s: DROP(0, 400000))
                DropBlackHole(x:400,000, d:100,000, m:50,000, s: FALL(c0))
        */
        
        //Expectation: {c0, right}
        let c_0 = Conveyor(index: 0, x1: 400000, x2: 1000000, y: 100)
        let c_1 = Conveyor(index: 1, x1: 000000, x2: 600000, y: 50)
        
        let conveyors = [c_0, c_1]
        _ = execute(name: "test_discovered_failure_case_x", conveyors: conveyors)
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
    
    static func test_1000_5_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 5, max_count: 5)
            if execute(name: "test_1000_5_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_5_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_1000_6_conveyor() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<1000 {
            
            let conveyors = GENERATE(min_count: 6, max_count: 6)
            if execute(name: "test_1000_6_conveyor_\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_1000_6_conveyor => Done! (passes = \(passes), fails = \(fails))")
    }
    
    static func test_100000_medium_harsh() {
        
        var passes = 0
        var fails = 0
        for test_index in 0..<100000 {
            
            let conveyors = GENERATE_HARSH(min_count: 1, max_count: 8)
            if execute(name: "test_100000_medium_harsh\(test_index)", conveyors: conveyors) {
                passes += 1
            } else {
                fails += 1
            }
            
        }
        print("test_100000_medium_harsh => Done! (passes = \(passes), fails = \(fails))")
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
                    let c = Conveyor(index: conveyorIndex, x1: x1, x2: x2, y: y)
                    result.append(c)
                    conveyorIndex += 1
                }
            }
            tryIndex += 1
        }
        
        return result
    }
    
    static func GENERATE_HARSH(min_count: Int, max_count: Int, tries: Int = 256) -> [Conveyor] {
        
        let count = Int.random(in: min(max_count, min_count)...max(max_count, min_count))
        
        var result = [Conveyor]()
        var tryIndex = 0
        var conveyorIndex = 0
        while result.count < count && tryIndex < tries {
            
            let x1 = Int.random(in: 0...1_000_000)
            let x2 = Int.random(in: 0...1_000_000)
            let y = Int.random(in: 0...900_000)
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
                    let c = Conveyor(index: conveyorIndex, x1: x1, x2: x2, y: y)
                    result.append(c)
                    conveyorIndex += 1
                }
                
                
            }
            
            tryIndex += 1
        }
        
        return result
    }
    
}
