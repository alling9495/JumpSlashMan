//
//  MapGenerator.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/13/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MapGenerator {
    
    func generateTileMap() -> SKTileMapNode {
        // Generate cells
        // Generate tilemap
        //
       return SKTileMapNode()
    }
    
    
    func generateMaze(x: Int, y: Int) -> [Int : UInt8] {
        let top = UInt8(0x1)
        let bot = UInt8(0x2)
        let left = UInt8(0x4)
        let right = UInt8(0x8)
        let randomGen = GKRandomDistribution(lowestValue: 0, highestValue: 99)
        
        var cells = [UInt8]()
        //var sets = [Set<Int>]()
        var idToSet = [Int: Set<Int>]()
        var cellToId = [Int : Int]()
        
        let defCell = UInt8(0x0)
        
        // For every row
        for row in 0..<y {
            print("Row #" + String(row))
            
            // add new cells
            for column in 0..<x {
                var newCell = defCell
                //print(String(row) + " " + String(column)
                
                if column == 0 {
                    newCell |= left
                } else if column == x - 1 {
                    newCell |= right
                }
                
                if row == 0 {
                    newCell |= top
                } else if row == y - 1 {
                    newCell |= bot
                }
                cells.append(newCell)
            }
            /* Set generation */
            //If not first row
            if (row != 0) {
                // Go through every column, check if has bottom, shove into set
                for normCol in 0..<x {
                    let curCol = normCol + row * x
                    let prevCol = normCol + (row - 1) * x
                    
                    print("not first row: " + String(curCol))
                    
                    if (cells[prevCol] & bot) > 0 {
                        print("Cell Has Bottom")
                        idToSet[curCol] = Set<Int>([curCol])
                        cellToId[curCol] = curCol
                    } else {
                        print("Cell Has No Bottom")
                        idToSet[cellToId[prevCol]!]!.insert(curCol)
                    }
                }
                print("Set Gen IdToSet: " + idToSet.description)
                print("Set Gen cellToId: " + cellToId.description)
            } else {
                for normCol in 0..<x {
                    let curCol = normCol + row * x
                    print("first row: " + String(curCol) + " " + String(normCol))
                    idToSet[curCol] = Set<Int>([curCol])
                    cellToId[curCol] = curCol
                }
            }
            var setOfSets = Set<Int>()
            /* Add Right Walls */
            //For every column except the last one
            for normCol in 0..<x - 1 {
                let curCol = normCol + row * x
                let nextCol = curCol + 1
                print("IdToSet: " + idToSet.description)
                print("cellToId: " + cellToId.description)
                // Decide whether to add wall to right randomly
                // If so, add wall, continue
                if randomGen.nextInt() > 50 {
                    print("Wall: " + String(curCol) + " " + String(nextCol))
                    cells[curCol] |= right
                    cells[nextCol] |= left
                    setOfSets.insert(cellToId[curCol]!)
                    
                } else { // Otherwise, join both cells into same set
                    // If they're not in the same set already
                    print("No Random Wall: " + String(curCol) + " " + String(nextCol))
                    print(cellToId[curCol]!)
                    print(cellToId[nextCol]!)
                    if !(idToSet[cellToId[curCol]!]!.contains(nextCol)) {
                        
                        if (cellToId[curCol]! < cellToId[nextCol]!) {
                            idToSet[cellToId[curCol]!]! = idToSet[cellToId[curCol]!]!.union(idToSet[cellToId[nextCol]!]!) // insert +1 cell to current
                            idToSet[cellToId[nextCol]!]!.removeAll() // remove from original
                            cellToId[nextCol]! = cellToId[curCol]! // change +1 cell's set to current cell set
                        } else {
                            idToSet[cellToId[nextCol]!]! = idToSet[cellToId[nextCol]!]!.union(idToSet[cellToId[curCol]!]!) // insert +1 cell to current
                            idToSet[cellToId[curCol]!]!.removeAll() // remove from original
                            cellToId[curCol]! = cellToId[nextCol]! // change +1 cell's set to current cell set
                        }
                        
                        
                        
                
                    } else {
                        print("Definite Wall: " + String(curCol) + " " + String(nextCol))
                        cells[curCol] |= right
                        cells[nextCol] |= left
                    }
                    
                    setOfSets.insert(cellToId[curCol]!)
                }
                print(curCol)
            }
            
            /* Add Bottom Walls */
            for set in setOfSets {
                let checkedSet = idToSet[set]!
                print("CheckSet: " + checkedSet.description)
                
                var count = 0
                for cell in checkedSet {
                    if randomGen.nextInt() > 50 {
                        if (count < checkedSet.count - 1) {
                            print("Assign Bottom: " + String(cell))
                            cells[cell] |= bot
                            count += 1
                        } else {
                            print("Did Not Assign Bottom: " + String(cell))
                        }
                    }
                }
                
            }
            
            print()
            
            for normCol in 0..<x {
                let curCol = normCol + row * x
                print(cellToId[curCol]!, terminator: " ")
            }
            print()
            
        }
        
        printMaze(x, y, cells)
        
        return [Int:UInt8]()
    }
    
    func printMaze(_ x: Int, _ y: Int, _ cells: [UInt8]) {
        let top = UInt8(0x1)
        let bot = UInt8(0x2)
        let left = UInt8(0x4)
        let right = UInt8(0x8)
        
        for row in 0..<y {
            for column in 0..<x {
                let curCol = column + row * x
                if (cells[curCol] & top) > 0 {
                    print("___ ", terminator: "")
                } else {
                    //print("", terminator: "")
                }
            }
            print()
            
            for column in 0..<x {
                let curCol = column + row * x
                
                if (cells[curCol] & left) > 0 {
                    print("|", terminator: "")
                } else {
                    print(" ", terminator: "")
                }
                
                print(terminator: "O")
                
                if  (cells[curCol] & right) > 0 {
                    print("|", terminator: " ")
                } else {
                    print(" ", terminator: " ")
                }
                
                //print(String(cells[column]) + " ", terminator: "")
            }
            
            print()
            
            for column in 0..<x {
                let curCol = column + row * x
                
                if (cells[curCol] & bot) > 0 {
                    print("___ ", terminator: "")
                } else {
                    //print("B", terminator: "")
                }
            }
            
            print()
        }
        
        print("\n")
    }
    
    func cellToTileMapNode() {
        
    }
    
}
