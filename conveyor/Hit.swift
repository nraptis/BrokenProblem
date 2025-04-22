//
//  Hit.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/22/25.
//

import Foundation

class Hit {
    var count: Int
    let length: Int
    let conveyor: Conveyor
    init(conveyor: Conveyor, length: Int, count: Int) {
        self.conveyor = conveyor
        self.length = length
        self.count = count
    }
}

class HitInfo {
    
    var dict = [LengthConveyor: Hit]()
    
    let conveyor: Conveyor
    init(conveyor: Conveyor) {
        self.conveyor = conveyor
    }
    
    func add(conveyor: Conveyor, length: Int, count: Int) {
        if conveyor.index != self.conveyor.index {
            fatalError("These should all be the same conveyor.")
        }
        let key = LengthConveyor(length: length, conveyor: conveyor)
        if let hit = dict[key] {
            hit.count += count
        } else {
            dict[key] = Hit(conveyor: conveyor, length: length, count: count)
        }
    }
}

class HitBag {
    var dict = [Conveyor: HitInfo]()
    
    func add(conveyor: Conveyor, length: Int, count: Int) {
        if let info = dict[conveyor] {
            info.add(conveyor: conveyor, length: length, count: count)
        } else {
            let info = HitInfo(conveyor: conveyor)
            info.add(conveyor: conveyor, length: length, count: count)
            dict[conveyor] = info
        }
    }
    
}


func calculateHits(conveyors: [Conveyor],
                       drops: [Drop]) {
    
    func bubbleDown(x: Int,
                    from: Conveyor,
                    conveyor: Conveyor,
                    length: Int,
                    count: Int) {
        
        if let hitBag = conveyor.hits[x] {
            hitBag.add(conveyor: from, length: length, count: count)
        } else {
            let hitBag = HitBag()
            hitBag.add(conveyor: from, length: length, count: count)
            conveyor.hits[x] = hitBag
        }
        
        if let right_collider = conveyor.right_collider {
            let additional_length = conveyor.x2 - x
            bubbleDown(x: conveyor.x2,
                       from: conveyor,
                       conveyor: right_collider,
                       length: length + additional_length,
                       count: count)
        }
        
        if let left_collider = conveyor.left_collider {
            let additional_length = x - conveyor.x1
            bubbleDown(x: conveyor.x1,
                       from: conveyor,
                       conveyor: left_collider,
                       length: length + additional_length,
                       count: count)
        }
    }
    
    for drop in drops {
        switch drop {
            
        case .conveyor(let span, let conveyor):
            
            let count = Conveyor.count(span: span)
            
            if let right_collider = conveyor.right_collider {
                bubbleDown(x: conveyor.x2,
                           from: conveyor,
                           conveyor: right_collider,
                           length: 0,
                           count: count)
            }
            
            if let left_collider = conveyor.left_collider {
                bubbleDown(x: conveyor.x1,
                           from: conveyor,
                           conveyor: left_collider,
                           length: 0,
                           count: count)
            }
            
        case .empty:
            break
        }
    }
    
    for conveyor in conveyors {
        let hit_xs = Array(conveyor.hits.keys).sorted()
        conveyor.hit_xs = hit_xs
        conveyor.hit_bags.reserveCapacity(hit_xs.count)
        
        for x in hit_xs {
            if let hitBag = conveyor.hits[x] {
                conveyor.hit_bags.append(hitBag)
                
            }
        }
        //conveyor.hits.removeAll()
        
    }
    
    
    // We go from the bottom-up...
    let conveyors = conveyors.sorted { $0.y < $1.y }
    
    
    
    for conveyor in conveyors {
        
        print("OUTER: \(conveyor)")
        
        if let right_collider = conveyor.right_collider {
            
            // We combine right_collider's splats with our hits.
            // This should reduce the number from explosive to
            // something like a "merge in the middle" instead of
            
            guard let splat_piece_left = right_collider.splat_info_left.dict[conveyor] else {
                fatalError("A There must be splat_piece_left when the right collider here.")
            }
            print("splat_piece_left is safe")
            
            guard let splat_piece_right = right_collider.splat_info_right.dict[conveyor] else {
                fatalError("B There must be splat_piece_right when the right collider here.")
            }
            
            var tuples = [(local_length: Int, splat_group: SplatGroup)]()
            for (local_length, splat_group) in splat_piece_left.dict {
                tuples.append((local_length, splat_group))
            }
            for (local_length, splat_group) in splat_piece_right.dict {
                tuples.append((local_length, splat_group))
            }
            
            for hit_index in conveyor.hit_xs.indices {
                let x = conveyor.hit_xs[hit_index]
                let hit_bag = conveyor.hit_bags[hit_index]
                
                let local_length_right = (conveyor.x2 - x)
                
                for (_, info) in hit_bag.dict {
                    for (_, hit) in info.dict {
                        let count = hit.count
                        
                        for tuple in tuples {
                            let tuple_local_length = tuple.local_length
                            // So, we would add local_length_right to tuple_local_length
                            let length_local = tuple_local_length + local_length_right
                            
                            let length_end = length_local + hit.length
                            conveyor.splat_info_right.add(conveyor: hit.conveyor,
                                                          length_local: length_local,
                                                          length_end: length_end,
                                                          count: count)
                        }
                        
                    }
                }
                
            }
            
        } else {
            
            // If there isn't a right collider:
            
            for hit_index in conveyor.hit_xs.indices {
                let x = conveyor.hit_xs[hit_index]
                let hit_bag = conveyor.hit_bags[hit_index]
                
                // How can we splat?
                let length_local = (conveyor.x2 - x)
                
                for (_, splat_info) in hit_bag.dict {
                    for (_, hit) in splat_info.dict {
                        let count = hit.count
                        let length_end = length_local + hit.length
                        conveyor.splat_info_right.add(conveyor: hit.conveyor,
                                                      length_local: length_local,
                                                      length_end: length_end,
                                                      count: count)
                    }
                }
            }
        }
        
        if let left_collider = conveyor.left_collider {
            
            // We combine right_collider's splats with our hits.
            // This should reduce the number from explosive to
            // something like a "merge in the middle" instead of
            
            guard let splat_piece_left = left_collider.splat_info_left.dict[conveyor] else {
                fatalError("C There must be splat_piece_left when the right collider here.")
            }
            print("splat_piece_left is safe")
            
            guard let splat_piece_right = left_collider.splat_info_right.dict[conveyor] else {
                fatalError("D There must be splat_piece_right when the right collider here.")
            }
            print("splat_piece_right is safe")
            
            var tuples = [(local_length: Int, splat_group: SplatGroup)]()
            for (local_length, splat_group) in splat_piece_left.dict {
                tuples.append((local_length, splat_group))
            }
            for (local_length, splat_group) in splat_piece_right.dict {
                tuples.append((local_length, splat_group))
            }
            
            for hit_index in conveyor.hit_xs.indices {
                let x = conveyor.hit_xs[hit_index]
                let hit_bag = conveyor.hit_bags[hit_index]
                
                let local_length_left = (x - conveyor.x1)
                
                for (_, info) in hit_bag.dict {
                    for (_, hit) in info.dict {
                        let count = hit.count
                        
                        for tuple in tuples {
                            let tuple_local_length = tuple.local_length
                            // So, we would add local_length_right to tuple_local_length
                            let length_local = local_length_left
                            
                            let length_end = length_local + hit.length
                            conveyor.splat_info_left.add(conveyor: hit.conveyor,
                                                          length_local: length_local,
                                                          length_end: length_end,
                                                          count: count)
                        }
                        
                    }
                }
                
            }
            
        } else {
            
            // If there isn't a left collider:
            
            for hit_index in conveyor.hit_xs.indices {
                let x = conveyor.hit_xs[hit_index]
                let hit_bag = conveyor.hit_bags[hit_index]
                
                // How can we splat?
                let length_local = (x - conveyor.x1)
                
                for (_, splat_info) in hit_bag.dict {
                    for (_, hit) in splat_info.dict {
                        let count = hit.count
                        let length_end = length_local + hit.length
                        conveyor.splat_info_left.add(conveyor: hit.conveyor,
                                                     length_local: length_local,
                                                     length_end: length_end,
                                                     count: count)
                    }
                }
            }
        }
        
        for hit_index in conveyor.hit_xs.indices {
            let x = conveyor.hit_xs[hit_index]
            let bag = conveyor.hit_bags[hit_index]
            for (_, info) in bag.dict {
                for (_, hit_original) in info.dict {
                    
                }
            }
            
        }
        
        for hit_bag in conveyor.hit_bags {
            
        }
        
        
    }
    
    
    var hit_list_right = [Hit]()
    var hit_list_left = [Hit]()
    
    
}

