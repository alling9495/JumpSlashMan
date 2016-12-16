//
//  GameScene.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/1/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

func * (point: CGPoint, scalar: Int) -> CGPoint {
    return CGPoint(x: point.x * CGFloat(scalar), y: point.y * CGFloat(scalar))
}

func * (point: CGPoint, scalar: Float) -> CGPoint {
    return CGPoint(x: point.x * CGFloat(scalar), y: point.y * CGFloat(scalar))
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let playerBitMask: UInt32 = 0x1
    let npcBitMask: UInt32 = 0x2
    let collisionBitMask: UInt32 = 0x1
    var leaderboardIdentifier: String?
    
    enum Dir {
        case still
        case up
        case down
        case left
        case right
    }
    
    private var npcSprite: SKSpriteNode?
    private var playerSprite : SKSpriteNode?
    private var testPlayerSprite: SKSpriteNode?
    private var floorSprite: SKTileMapNode?
    private var mazeSprite: SKTileMapNode?
    private var prevPosition: CGPoint?
    private var direction = Dir.still
    private let origMoveSpeed = 24.0
    private var moveSpeed = 24.0
    private let byNumber = 0
    private var currentByNumber = 0
    private var leaderboard: GKLeaderboard?
    private let dashDistance = 120
    private var ninja = NinjaPlayer()
    
    func swipeDiag(sender: DiagonalSwipeRecognizer) {
        if (sender.state == .ended) {
            //print(String(describing: sender.direction))
            
            if (sender.direction == .ne) {
                if (direction != Dir.up) {
                    direction = Dir.up
                } else {
                    dash(CGPoint(x: 0, y: dashDistance), self.ninja.attackNE.frames)
                }
            } else if (sender.direction == .nw) {
                if (direction != Dir.left) {
                    direction = Dir.left
                } else {
                   dash(CGPoint(x: -dashDistance, y: 0), self.ninja.attackNW.frames)
                }
            } else if (sender.direction == .se) {
                if (direction != Dir.right) {
                    direction = Dir.right
                } else {
                    dash(CGPoint(x: dashDistance, y: 0), self.ninja.attackSE.frames)
                }
            } else if (sender.direction == .sw) {
                if (direction != Dir.down) {
                    direction = Dir.down
                } else {
                    dash(CGPoint(x: 0, y: -dashDistance), self.ninja.attackSW.frames)
                }
            }

        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.playerSprite = self.childNode(withName: "//Player") as? SKSpriteNode
        self.playerSprite?.removeFromParent()
        if let _ = self.playerSprite {
           
            self.playerSprite!.physicsBody!.categoryBitMask = playerBitMask
            self.playerSprite!.physicsBody!.contactTestBitMask = npcBitMask
            self.playerSprite!.physicsBody!.collisionBitMask = 0x1
             print(self.playerSprite!.description, terminator: "\n")
            

        } else {
            print("PlayerSprite, no go")
        }
        
        self.npcSprite = self.childNode(withName: "//NPC") as? SKSpriteNode
        
        if let _ = self.npcSprite {
           self.npcSprite!.physicsBody!.categoryBitMask = npcBitMask
           self.npcSprite!.physicsBody!.contactTestBitMask = playerBitMask
            self.npcSprite!.physicsBody!.collisionBitMask = 0x2
            print(self.npcSprite!.description, terminator: "\n")

        } else {
            print("NPCSprite, no go")
        }
        
        self.floorSprite = self.childNode(withName: "firstTileNode") as? SKTileMapNode
        
        if let floorSprite = self.floorSprite {
            self.prevPosition = floorSprite.position;
            
            let w = floorSprite.frame.width
            //let h = floorSprite.frame.height
            
            //let h = floorSprite.frame.height
            //let h = CGFloat(143.11 * 3.15)
            
            let dist = w
            
            let point = point2DToIso(p: CGPoint(x: self.prevPosition!.x, y: self.prevPosition!.y + dist))
            
            //let point1 = point2DToIso(p: CGPoint(x: self.prevPosition!.x, y: self.prevPosition!.y - dist))
            
            //let point2 = point2DToIso(p: CGPoint(x: self.prevPosition!.x - dist, y: self.prevPosition!.y))
            
            //let point3 = point2DToIso(p: CGPoint(x: self.prevPosition!.x + dist, y: self.prevPosition!.y))
        
            self.floorSprite!.addChild(addNewTileNode(location: point))
            self.floorSprite!.addChild(addNewTileNode(location: point * 2))
            self.floorSprite!.addChild(addNewTileNode(location: point * 2.5))
            self.floorSprite!.addChild(addNewTileNode(location: point * 3))
        } else {
            print("floorSprite Assignment failed")
        }
        
        
        let diagSwipe:DiagonalSwipeRecognizer = DiagonalSwipeRecognizer(target: self, action: #selector(swipeDiag))
        view.addGestureRecognizer(diagSwipe)
        
        print("PlayerSprite Mask" + self.playerSprite!.physicsBody!.description)
        
        print("NPCSprite Mask" + self.npcSprite!.physicsBody!.description)
        
        let mg = MazeGenerator()
        let cells = mg.generateMaze(x: 49, y: 49)
        
        let newTile = mg.convertToTileMapNode(49, 49, cells)
        newTile.xScale = 2
        newTile.yScale = 2
        newTile.anchorPoint = CGPoint(x: 0.5, y: 0.125)
        self.mazeSprite = newTile
        self.floorSprite!.addChild(newTile)
        
        self.testPlayerSprite = SKSpriteNode(texture: self.ninja.attackNE.frames[0])
        self.testPlayerSprite!.xScale = 2
        self.testPlayerSprite!.yScale = 2
        
        self.addChild(testPlayerSprite!)
    
    }
    
    func touchDown(atPoint pos : CGPoint) {
        /* if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        } */

       /* if let floorSprite = self.floorSprite, var prevPosition = self.prevPosition{
            prevPosition.y += 1
            let newPos = point2DToIso(p: prevPosition)
            floorSprite.position = newPos
        }*/
        
        self.childNode(withName: "//Title")?.removeFromParent()
        self.childNode(withName: "//Subheading")?.removeFromParent()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        // if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //     n.position = pos
        //     n.strokeColor = SKColor.blue
        //     self.addChild(n)
        // }
    
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        // if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //     n.position = pos
        //     n.strokeColor = SKColor.red
        //     self.addChild(n)
        // }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var numeroUno: SKPhysicsBody?
        var numeroDos: SKPhysicsBody?
        print("????")
        
        // If player is A
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask  {
            numeroUno = contact.bodyA
            numeroDos = contact.bodyB
        } else {
            numeroUno = contact.bodyB
            numeroDos = contact.bodyA
        }
        
        
        
        if let leadId = leaderboardIdentifier {
            let newScore = GKScore(leaderboardIdentifier: leadId)
            
            newScore.value = 1000
            
            GKScore.report([newScore]) {
                (error) -> Void in
                print("Reported!")
            }
            
            let leaderboard = GKLeaderboard(players: [GKLocalPlayer.localPlayer()])
            leaderboard.identifier = leadId
            leaderboard.loadScores {
                (scores, error) in
                if let allScores = scores {
                    for score in allScores {
                        print("Score Value: " + String(score.value))
                    }
                }
            }
            
            numeroDos?.node?.removeFromParent()
        }
        
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        /* if let playerSprite = self.playerSprite, var _ = self.prevPosition{
            self.prevPosition!.y += 0.5
            let newPos = point2DToIso(p: self.prevPosition!)
            playerSprite.position = newPos
        } */
        
        if let _ = self.floorSprite, var _ = self.prevPosition {
            //print(self.testPlayerSprite?.position)
            
            let origin = self.testPlayerSprite!.position            
            let newPoint = self.mazeSprite!.convert(origin, from: self.mazeSprite!.scene!)
            //print(newPoint)
            
            let rowIndex = self.mazeSprite!.tileRowIndex(fromPosition: newPoint)
            let colIndex = self.mazeSprite!.tileColumnIndex(fromPosition: newPoint)
            
            let tileDef = self.mazeSprite!.tileGroup(atColumn: colIndex, row: rowIndex)
            
            //print(tileDef!.name)
            if (tileDef!.name! != "Grass") {
                    self.moveSpeed = self.origMoveSpeed / 4
            } else {
                    self.moveSpeed = self.origMoveSpeed
            }
            
            
            if (currentByNumber >= byNumber) {
                currentByNumber = 0
            } else {
                currentByNumber += 1
            }
            
            
            switch direction {
            case Dir.still:
                break
            case Dir.up:
                move() { () -> Void in
                    self.prevPosition!.y -= CGFloat(self.moveSpeed)
                    self.testPlayerSprite?.texture = self.ninja.moveNE.nextFrame()
                }
            case Dir.down:
                move() { () -> Void in
                    self.prevPosition!.y += CGFloat(self.moveSpeed)
                    self.testPlayerSprite?.texture = self.ninja.moveSW.nextFrame()
                }
            case Dir.right:
                move() { () -> Void in
                    self.prevPosition!.x -= CGFloat(self.moveSpeed)
                    self.testPlayerSprite?.texture = self.ninja.moveSE.nextFrame()
                }
            case Dir.left:
                move() {() -> Void in
                    self.prevPosition!.x += CGFloat(self.moveSpeed)
                    self.testPlayerSprite?.texture = self.ninja.moveNW.nextFrame()
                }
            }
           
        }
    
    }
    
    func dash(_ dashPoint: CGPoint, _ anim: [SKTexture]) {
        let newPos = point2DToIso(p: dashPoint)

        
        /* switch direction {
        case Dir.still:
            break
        case Dir.up:
            move() { () -> Void in
                self.prevPosition!.y -= CGFloat(self.moveSpeed)
                self.testPlayerSprite?.texture = self.ninja.moveNE.nextFrame()
            }
        case Dir.down:
            move() { () -> Void in
                self.prevPosition!.y += CGFloat(self.moveSpeed)
                self.testPlayerSprite?.texture = self.ninja.moveSW.nextFrame()
            }
        case Dir.right:
            move() { () -> Void in
                self.prevPosition!.x -= CGFloat(self.moveSpeed)
                self.testPlayerSprite?.texture = self.ninja.moveSE.nextFrame()
            }
        case Dir.left:
            move() {() -> Void in
                self.prevPosition!.x += CGFloat(self.moveSpeed)
                self.testPlayerSprite?.texture = self.ninja.moveNW.nextFrame()
            }
        } */
        
        let newAction = SKAction.move(by: CGVector(dx: newPos.x, dy: newPos.y), duration: 0.3)
        let animate = SKAction.animate(with: anim, timePerFrame: 0.033)
        let group = SKAction.group([newAction, animate])
        let seq = SKAction.sequence([group, newAction.reversed()])
        
        self.testPlayerSprite!.run(seq)
    }
    
    
    func move(moveDir: () -> Void) {
        if let floorSprite = self.floorSprite, var _ = self.prevPosition{
            moveDir()
            let newPos = point2DToIso(p: self.prevPosition!)
            floorSprite.position = newPos
        }
    }
    
    func point2DToIso(p:CGPoint) -> CGPoint {
    
        //invert y pre conversion
        var point = p * CGPoint(x:1, y:-1)
    
        //convert using algorithm
        point = CGPoint(x:(point.x - point.y), y: ((point.x + point.y) / 2))
    
        //invert y post conversion
        point = point * CGPoint(x:1, y:-1)
    
        return point
    
    }
    
    func pointIsoTo2D(p:CGPoint) -> CGPoint {
        
        //invert y pre conversion
        var point = p * CGPoint(x:1, y:-1)
        
        //convert using algorithm
        point = CGPoint(x:((2 * point.y + point.x) / 2), y: ((2 * point.y - point.x) / 2))
        
        //invert y post conversion
        point = point * CGPoint(x:1, y:-1)
        
        return point
        
    }
    
    func addNewTileNode(location:CGPoint) -> SKTileMapNode {
        let newTileSet = SKTileSet(named: "tileSet1")
        let tileSize = CGSize(width: 128, height: 64)
        let newTile = SKTileMapNode(tileSet: newTileSet!, columns: 7, rows: 7, tileSize: tileSize)
        
        //newTileSet?.tileGroups[0]
        let backgroundGroup = newTileSet?.tileGroups[0]
        
        newTile.fill(with: backgroundGroup)
        newTile.position = location
        
        return newTile
    }
    
}
