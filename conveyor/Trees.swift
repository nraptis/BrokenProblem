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

final class AVLTreeNode {
    var value: Conveyor
    var height: Int
    var count: Int
    var left: AVLTreeNode?
    var right: AVLTreeNode?
    init(value: Conveyor, height: Int, count: Int) {
        self.value = value
        self.height = height
        self.count = count
    }
}

class AVLTree {
    
    var root: AVLTreeNode?
    
    private func count(_ node: AVLTreeNode?) -> Int {
        node?.count ?? 0
    }
    
    func height() -> Int {
        height(root)
    }
    
    private func height(_ node: AVLTreeNode?) -> Int {
        node?.height ?? -1
    }
    func insert(_ element: Conveyor) {
        root = insert(root, element)
    }
    
    private func insert(_ node: AVLTreeNode?, _ element: Conveyor) -> AVLTreeNode {
        guard let node = node else {
            return AVLTreeNode(value: element, height: 0, count: 1)
        }
        if element.y < node.value.y {
            node.left = insert(node.left, element)
        } else if element.y > node.value.y {
            node.right = insert(node.right, element)
        } else {
            return node
        }
        node.count = 1 + count(node.left) + count(node.right)
        node.height = 1 + max(height(node.left), height(node.right))
        return balance(node)
    }
    
    func remove(_ element: Conveyor) {
        root = remove(root, element)
    }
    
    private func remove(_ node: AVLTreeNode?, _ element: Conveyor) -> AVLTreeNode? {
        guard var node = node else {
            return nil
        }
        if element.y < node.value.y {
            node.left = remove(node.left, element)
        } else if element.y > node.value.y {
            node.right = remove(node.right, element)
        } else {
            if node.left == nil {
                return node.right
            } else if node.right == nil {
                return node.left
            } else {
                let swap = node
                if let right = swap.right {
                    node = right
                    while let left = node.left {
                        node = left
                    }
                    node.right = removeMin(right)
                }
                node.left = swap.left
            }
        }
        node.count = 1 + count(node.left) + count(node.right)
        node.height = 1 + max(height(node.left), height(node.right))
        return balance(node)
    }
    
    func removeMin(_ node: AVLTreeNode) -> AVLTreeNode? {
        if let left = node.left {
            node.left = removeMin(left)
        } else {
            return node.right
        }
        node.count = 1 + count(node.left) + count(node.right)
        node.height = 1 + max(height(node.left), height(node.right))
        return balance(node)
    }
    
    private func rotateRight(_ node: AVLTreeNode) -> AVLTreeNode {
        guard let swap = node.left else {
            return node
        }
        node.left = swap.right
        swap.right = node
        swap.count = node.count
        node.count = 1 + count(node.left) + count(node.right)
        node.height = 1 + max(height(node.left), height(node.right))
        swap.height = 1 + max(height(swap.left), height(swap.right))
        return swap
    }
    
    private func rotateLeft(_ node: AVLTreeNode) -> AVLTreeNode {
        guard let swap = node.right else {
            return node
        }
        node.right = swap.left
        swap.left = node
        swap.count = node.count
        node.count = 1 + count(node.left) + count(node.right)
        node.height = 1 + max(height(node.left), height(node.right))
        swap.height = 1 + max(height(swap.left), height(swap.right))
        return swap
    }
    
    private func balanceFactor(_ node: AVLTreeNode) -> Int {
        return height(node.left) - height(node.right)
    }
    
    private func balance(_ node: AVLTreeNode) -> AVLTreeNode {
        var swap = node
        if balanceFactor(swap) < -1 {
            if let right = swap.right {
                if balanceFactor(right) > 0 {
                    swap.right = rotateRight(right)
                }
            }
            swap = rotateLeft(swap)
        } else if balanceFactor(swap) > 1 {
            if let left = swap.left {
                if balanceFactor(left) < 0 {
                    swap.left = rotateLeft(left)
                }
            }
            swap = rotateRight(swap)
        }
        return swap
    }
    
    func best(y: Int) -> Conveyor? {
        var result: Conveyor?
        func findBest(node: AVLTreeNode?, y: Int, difference: Int) {
            guard let node = node else {
                return
            }
            let conveyor = node.value
            if conveyor.y < y {
                var new_difference = (y - conveyor.y)
                if new_difference < difference {
                    result = conveyor
                } else {
                    new_difference = difference
                }
                return findBest(node: node.right, y: y, difference: new_difference)
            } else {
                return findBest(node: node.left, y: y, difference: difference)
            }
        }
        findBest(node: root, y: y, difference: Int.max)
        return result
    }
}
