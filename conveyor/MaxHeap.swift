//
//  MaxheapIndexedHeap.swift
//  conveyor
//
//  Created by Nicholas Raptis on 4/20/25.
//

import Foundation

class MaxHeap {
    
    private(set) var data = [Conveyor]()
    private(set) var count: Int = 0
    
    func insert(_ element: Conveyor?) {
        if let element = element {
            if count < data.count {
                data[count] = element
            } else {
                data.append(element)
            }
            data[count].heapIndex = count
            var bubble = count
            var parent = (((bubble - 1)) >> 1)
            count += 1
            while bubble > 0 {
                if data[bubble].y > data[parent].y {
                    data.swapAt(bubble, parent)
                    let holdheapIndex = data[bubble].heapIndex
                    data[bubble].heapIndex = data[parent].heapIndex
                    data[parent].heapIndex = holdheapIndex
                    bubble = parent
                    parent = (((bubble - 1)) >> 1)
                } else {
                    break
                }
            }
        }
    }
    
    func peek() -> Conveyor? {
        if count > 0 { return data[0] }
        return nil
    }
    
    func pop() -> Conveyor? {
        if count > 0 {
            let result = data[0]
            count -= 1
            data[0] = data[count]
            data[0].heapIndex = 0
            
            var bubble = 0
            var leftChild = 1
            var rightChild = 2
            var maxChild = 0
            while leftChild < count {
                maxChild = leftChild
                if rightChild < count && data[rightChild].y > data[leftChild].y {
                    maxChild = rightChild
                }
                if data[bubble].y < data[maxChild].y {
                    data.swapAt(bubble, maxChild)
                    let holdheapIndex = data[bubble].heapIndex
                    data[bubble].heapIndex = data[maxChild].heapIndex
                    data[maxChild].heapIndex = holdheapIndex
                    bubble = maxChild
                    leftChild = bubble * 2 + 1
                    rightChild = leftChild + 1
                } else {
                    break
                }
            }
            return result
        }
        return nil
    }
    
    var isEmpty: Bool {
        count == 0
    }
    
    func remove(_ element: Conveyor) {
        _ = remove(at: element.heapIndex)
    }
    
    func remove(at heapIndex: Int) -> Conveyor? {
        let newCount = count - 1
        if heapIndex != newCount {
            data.swapAt(heapIndex, newCount)
            
            var holdheapIndex = data[heapIndex].heapIndex
            data[heapIndex].heapIndex = data[newCount].heapIndex
            data[newCount].heapIndex = holdheapIndex
            
            var bubble = heapIndex
            var leftChild = bubble * 2 + 1
            var rightChild = leftChild + 1
            var maxChild = 0
            while leftChild < newCount {
                maxChild = leftChild
                if rightChild < newCount && data[rightChild].y > data[leftChild].y {
                    maxChild = rightChild
                }
                if data[bubble].y < data[maxChild].y {
                    data.swapAt(bubble, maxChild)
                    
                    holdheapIndex = data[bubble].heapIndex
                    data[bubble].heapIndex = data[maxChild].heapIndex
                    data[maxChild].heapIndex = holdheapIndex
                    
                    bubble = maxChild
                    leftChild = bubble * 2 + 1
                    rightChild = leftChild + 1
                } else {
                    break
                }
            }
            bubble = heapIndex
            var parent = (((bubble - 1)) >> 1)
            while bubble > 0 {
                if data[bubble].y > data[parent].y {
                    data.swapAt(bubble, parent)
                    
                    holdheapIndex = data[bubble].heapIndex
                    data[bubble].heapIndex = data[parent].heapIndex
                    data[parent].heapIndex = holdheapIndex
                    
                    bubble = parent
                    parent = (((bubble - 1)) >> 1)
                } else {
                    break
                }
            }
        }
        count = newCount
        return data[count]
    }
}
