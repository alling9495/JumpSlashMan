//
//  File.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/14/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class MazeGenerator {
    let top = UInt8(0x1)
    let bot = UInt8(0x2)
    let left = UInt8(0x4)
    let right = UInt8(0x8)
    let defCell = UInt8(0x0)
    let randomGen = GKRandomDistribution(lowestValue: 0, highestValue: 99)
    let percentAddWall = 30
    let percentAddBottom = 50
    var setMan = SetManager()
    
    func generateMaze(x: Int, y: Int) {
        let rowSize = y
        let colSize = x
        
        var cells = [UInt8]()
        
    
        /* For every row */
            /* Add blank cells */
                /* If left, right, top, and or bottom, add appropriate wall */
        
            /* If not the first row, check above rows for bottom walls */
        
            /* For all unassigned cells, add to own set */
            /* For every column */
                /* Add walls going left to right */
                    /* If both cells are in the same set, add a wall */
                    /* Else */
                        /* Randomly decide to add wall */
                        /* If so, add wall */
                        /* Else */
                            /* Union current cell and neighbor */

                /* Add bottoms going left to right */
                    /* If only cell in set, do not add */
                    /* Randomly decide to add bottom */
                    /* If so, check if only cell in set with no bottom */
        
        
        for row in 0..<rowSize {
            /* Add blank cells */
            for column in 0..<colSize {
                var newCell = defCell
                //print(String(row) + " " + String(column)
                
                if column == 0 {
                    newCell |= left
                } else if column == colSize - 1 {
                    newCell |= right
                }
                
                if row == 0 {
                    newCell |= top
                } else if row == rowSize - 1 {
                    newCell |= bot
                }
                cells.append(newCell)
            }
            
            /* Check above for bottoms */
            if (row != 0) {
                print("Checking for vertical connections")
                for normCol in 0..<colSize {
                    let curCol = normCol + row * colSize
                    let prevCol = normCol + (row - 1) * colSize
                    
                    if (cells[prevCol] & bot) > 0 {
                        setMan.insertToEmpty(curCol)
                    } else {
                        setMan.insertToOther(targ: prevCol, curCol)
                    }
                }
            }
            
            /* For all unassigned cells, add to set */
            for normCol in 0..<colSize {
                let curCol = normCol + row * colSize
                setMan.insertToEmpty(curCol)
            }
            
            
            var currentRowSets = Set<Set<Int>>()
        
            
                /* Add walls */
                for normCol in 0..<colSize - 1 {
                    let curCell = normCol + row * colSize
                    let nextCell = curCell + 1
                
                    print("Cells: " + String(curCell) + " " + String(nextCell))
                
                    if setMan.sameSet(curCell, nextCell) || randomGen.nextInt() > percentAddWall {
                        print("Adding a wall" + String(setMan.sameSet(curCell, nextCell)))
                        cells[curCell] |= right
                        cells[nextCell] |= left
                    
                        currentRowSets.insert(setMan.getSet(cell: curCell))
                    
                        /* Make sure to get last set in row */
                        if (normCol == colSize - 2) {
                            currentRowSets.insert(setMan.getSet(cell: nextCell))
                        }
                    } else {
                        print("Not Adding A Wall")
                        let newSet = setMan.union(cell1: curCell, cell2: nextCell)
                    
                        currentRowSets.insert(newSet)
                    }
                }
            
                /* Add bottoms */
            
                for set in currentRowSets {
                    let count = set.count
                
                    print("Set: " + set.description)
                
                    /* If not the only cell and you decide to add */
                    if count != 1 {
                        var bottomsAdded = 0
                        for cell in set {
                            if randomGen.nextInt() > percentAddBottom && bottomsAdded < count - 1 {
                                cells[cell] |= bot
                                bottomsAdded += 1
                            }
                        }
                    }
                }
        }
        
        /* Finish maze */
        print("Finishing Maze")
        for normCol in 0..<colSize - 1 {
            let curCell = normCol + (rowSize - 1) * colSize
            let nextCell = curCell + 1
            print("Cells: " + String(curCell) + " " + String(nextCell))
            if !setMan.sameSet(curCell, nextCell) {
                /* Remove walls between */
                cells[curCell] ^= right
                cells[nextCell] ^= left
                
                /* Union together */
                _ = setMan.union(cell1: curCell, cell2: nextCell)
            }
            
        }
        
        printMaze(x, y, cells)
        
        
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
    
    
}




/* Utility functions */


class SetManager {
    
    /* Insert into set */
    /* Get set associated with cell and insert */
    /* Union and ignore both old sets */
    var cellNumberToSet = [Int: Set<Int>]()
    
    /* Insert into own set */
    func insertToEmpty(_ cell: Int) {
        /* If cell exists, don't insert */
        /* Check if any empty */
        /* If so, add to empty set */
        /* else, make new set, add to it */
        var newSet: Set<Int>
        
        if let _ = cellNumberToSet[cell] {
            
        } else {
            newSet = Set<Int>()
            newSet.insert(cell)
            
            cellNumberToSet[cell] = newSet
        }
        
    
    }
    
    func insertToOther(targ: Int, _ cell: Int) {
        /* Get target cell's set */
        /* Insert new cell to target cell's set */
        
        var targSet = cellNumberToSet[targ]!
        targSet.insert(cell)

    }
    
    func getSet(cell: Int) -> Set<Int> {
        print("Get: " + cellNumberToSet.description)
        return cellNumberToSet[cell]!
    }
    
    /* Union both cell's sets together */
    func union(cell1: Int, cell2: Int) -> Set<Int>{
        /* Find set of both cells */
        let set1 = cellNumberToSet[cell1]!
        let set2 = cellNumberToSet[cell2]!
        /* Union together */
        let set3 = set1.union(set2)
    
        /* Set both cellNumbers to new set in map */
        cellNumberToSet[cell1] = set3
        cellNumberToSet[cell2] = set3
        return set3
    }
    
    /* Check if both cells in same set */
    func sameSet(_ cell1: Int, _ cell2: Int) -> Bool {
        /* Find set of both cells */
        let set1 = cellNumberToSet[cell1]!
        let set2 = cellNumberToSet[cell2]!
        /* Return contains */
        return set1.elementsEqual(set2)
    }
    
}


/* Figure out cell's set */
/* Figure out other set */
