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
    private var floorSprite: SKTileMapNode?
    private var prevPosition: CGPoint?
    private var direction = Dir.still
    private let moveSpeed = 8.0
    private var leaderboard: GKLeaderboard?
    
    func swipeDiag(sender: DiagonalSwipeRecognizer) {
        if (sender.state == .ended) {
            print(String(describing: sender.direction))
            
            if (sender.direction == .ne) {
                direction = Dir.up
            } else if (sender.direction == .nw) {
                direction = Dir.left
            } else if (sender.direction == .se) {
                direction = Dir.right
            } else if (sender.direction == .sw) {
                direction = Dir.down
            }

        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.playerSprite = self.childNode(withName: "//Player") as? SKSpriteNode
        
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
        } else {
            print("floorSprite Assignment failed")
        }
 
        let diagSwipe:DiagonalSwipeRecognizer = DiagonalSwipeRecognizer(target: self, action: #selector(swipeDiag))
        view.addGestureRecognizer(diagSwipe)
        
        print("PlayerSprite Mask" + self.playerSprite!.physicsBody!.description)
        
        print("NPCSprite Mask" + self.npcSprite!.physicsBody!.description)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        /* if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        } */

        if let floorSprite = self.floorSprite, var prevPosition = self.prevPosition{
            prevPosition.y += 1
            let newPos = point2DToIso(p: prevPosition)
            floorSprite.position = newPos
        }
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
        if let _ = self.floorSprite, var _ = self.prevPosition{
            switch direction {
            case Dir.still:
                break
            case Dir.up:
                move() { () -> Void in
                    self.prevPosition!.y -= CGFloat(self.moveSpeed)
                }
            case Dir.down:
                move() { () -> Void in
                    self.prevPosition!.y += CGFloat(self.moveSpeed)
                }
            case Dir.right:
                move() { () -> Void in
                    self.prevPosition!.x -= CGFloat(self.moveSpeed)
                }
            case Dir.left:
                move() {() -> Void in
                    self.prevPosition!.x += CGFloat(self.moveSpeed)
                }
            }
        }
    
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
}
