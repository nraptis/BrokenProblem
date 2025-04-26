//
//  Runner.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/16/25.
//

import Foundation

struct Runner {
    
    static func test_example_1() {
        let c_0 = Conveyor(index: 0, x1: 100000, x2: 600000, y: 10)
        let c_1 = Conveyor(index: 1, x1: 400000, x2: 800000, y: 20)
        let conveyors = [c_0, c_1]
        let result = getMinExpectedHorizontalTravelDistance(conveyors: conveyors)
        print("test_example_1 => \(result)")
    }
    
    static func test_example_2() {
        let c_0 = Conveyor(index: 0, x1: 5000, x2: 7000, y: 2)
        let c_1 = Conveyor(index: 1, x1: 2000, x2: 8000, y: 8)
        let c_2 = Conveyor(index: 2, x1: 7000, x2: 11000, y: 5)
        let c_3 = Conveyor(index: 3, x1: 9000, x2: 11000, y: 9)
        let c_4 = Conveyor(index: 4, x1: 0, x2: 4000, y: 4)
        let conveyors = [c_0, c_1, c_2, c_3, c_4]
        let result = getMinExpectedHorizontalTravelDistance(conveyors: conveyors)
        print("test_example_2 => \(result)")
    }
    
    static func run() {
        
        
        test_example_1()
        test_example_2()
        
        Cumulator_Test.test_tiny_example_000()
        Cumulator_Test.test_tiny_example_001()
        Cumulator_Test.test_tiny_example_002()
        
        Cumulator_Test.test_double_example_000()
        
        BruteTests.test_1000_2_conveyor()
        BruteTests.test_1000_3_conveyor()
        BruteTests.test_1000_4_conveyor()
        BruteTests.test_1000_5_conveyor()
        BruteTests.test_1000_6_conveyor()
        
        
        
        //let MED3 = getMinExpectedHorizontalTravelDistance(TestCase.test_touching_ends_a)
        //print("MED3: \(MED3)")
        
        //let MED3 = getMinExpectedHorizontalTravelDistance(TestCase.test_tiny)
        //print("MED3: \(MED3)")
        
        //Cumulator_Test.test_tiny_example_000()
        //Cumulator_Test.test_tiny_example_001()
        //Cumulator_Test.test_tiny_example_002()
        
        
        
        //ColliderTests.test_all()
        
        
        
        //Test_Case_Explorer.test(TestCase.test_case_4)
        
        
        //BruteTests.test_example_1()
        
        //BruteTests.test_all()
        
        //test_discovered_failure_case_c
        //test_discovered_failure_case_d
        
        
        //BruteTests.test_discovered_failure_case_e()
        
        //BruteTests.test_discovered_failure_case_v()
        
        //print("o")
        
        //BruteTests.test_discovered_failure_case_w()
        
        //BruteTests.test_all()
        
        //BruteTests.test_discovered_failure_case_x()
        
        //BruteTests.test_discovered_failure_case_u()
        
        
        //BruteTests.test_all()
        
        
        
        
        //BruteTests.test_example_1()
        //BruteTests.test_discovered_failure_case_a()
        
        
        
        
        
        print("ooo")
        print("oo")
        print("o")
        
        
        //BruteTests.test_discovered_failure_case_k()
        
        
        
        
        //BruteTests.test_1000_three_conveyor()
        //BruteTests.test_100_four_conveyor()
        
        
        //BruteTests.execute(name: "test_case_1", conveyors: TestCase.test_case_1.conveyors)
        //BruteTests.execute(name: "test_case_2", conveyors: TestCase.test_case_2.conveyors)
        
        //BruteTests.test_discovered_failure_case_b()
        //BruteTests.test_discovered_failure_case_a()
        
        
        //BruteTests.test_10000_twenty_conveyor()
        
        //BruteTests.test_100_two_conveyor()
        //BruteTests.test_100_three_conveyor()
        //BruteTests.test_100_four_conveyor()
        //BruteTests.test_100_twenty_conveyor()
        
        //let MED1 = getMinExpectedHorizontalTravelDistance(TestCase.test_case_1)
        //print("MED1: \(MED1)")
        
        //let MED2 = getMinExpectedHorizontalTravelDistance(TestCase.test_case_2)
        //print("MED2: \(MED2)")
        
        
        //let STAIR = getMinExpectedHorizontalTravelDistance(TestCase.test_case_stairs)
        //print("STAIR: \(STAIR)")
        
        
        //let FIVEBANG = getMinExpectedHorizontalTravelDistance(TestCase.test_case_five_banger)
        //print("FIVEBANG: \(FIVEBANG)")
        
        //let STAIR_D = getMinExpectedHorizontalTravelDistance(TestCase.test_case_stairs_with_double)
        //print("STAIR_D: \(STAIR_D)")
        
        
        //let STAIR_INV = getMinExpectedHorizontalTravelDistance(TestCase.test_case_stairs_inverted)
        //print("STAIR_INV: \(STAIR_INV)")
        
        
        //CombineDuplicates_Test.test_all()
        
        
        //CombineDuplicates_Test.test_failed_case_a()
        
        
        //let LARGE = getMinExpectedHorizontalTravelDistance(TestCase.test_case_large)
        //print("LARGE: \(LARGE)")
        
        
        
        
        
        
        //FindLeftRightSets_Tests.test_example_a()
        
        /*
        FindColliders_Tests.test_simple_overlap_under_mono()
        
        
        FindColliders_Tests.test_example_one()
        
        FindColliders_Tests.test_no_conveyors()
        
        FindColliders_Tests.test_one_conveyor_small()
        FindColliders_Tests.test_one_conveyor_ten()
        FindColliders_Tests.test_simple_gap()
        FindColliders_Tests.test_simple_overlap()
        
        
        
        FindColliders_Tests.test_mixed_overlap_under_mono()
        FindColliders_Tests.test_mixed_overlap_under_mono_with_flare()
        FindColliders_Tests.test_failed_test_a()
        FindColliders_Tests.test_failed_test_b()
        FindColliders_Tests.test_failed_test_c()
        FindColliders_Tests.test_failed_test_d()
        FindColliders_Tests.test_failed_test_e()
        */
        
        //FindColliders_Tests.test_failed_test_g()
        
        //FindColliders_Tests.test_failed_test_h()
        
        //FindColliders_Tests.test_all()
        
        //print("TERMINAL!!!")
        
        //FindColliders_Tests.test_all()
        
        /*
        FindColliders_Tests.test_10000_twenty_conveyor()
        FindColliders_Tests.test_10000_to_max()
        
        FindColliders_Tests.test_100000_whole_lotta_love()
        */
        
        
        
        
        
        
        
        
        /*
        let MED = getMinExpectedHorizontalTravelDistance(TestCase.test_case_stepper_1)
        
        
        
        Boundary_Tests.run_closed_closed()
        Boundary_Tests.run_closed_open()
        Boundary_Tests.run_open_closed()
        Boundary_Tests.run_open_open()
        
        
        Drop_Tests.test_no_conveyors()
        */
        
        //Drop_Tests.test_all()
        
        //Drop_Tests.test_one_conveyor_small()
        
        
        //Drop_Tests.test_failed_test_a()
        
        //Drop_Tests.test_failed_test_b()
        
        
        
        //Drop_Tests.test_all()
        
        
        
        
        
        //Drop_Tests.test_all()
        
        //Drop_Tests.test_failed_test_e()
        
        
        //Drop_Tests.test_failed_test_c()
        //Drop_Tests.test_failed_test_d()
        
        
        //test_all()
        
        //Drop_Tests.test_mixed_overlap_under_mono_with_flare()
        
        //Drop_Tests.test_mixed_overlap_under_mono()
        
        
    }
}
