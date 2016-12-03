//
//  GameScene.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/1/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import SpriteKit
import GameplayKit

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


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var playerSprite : SKSpriteNode?
    private var prevPosition: CGPoint?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        self.playerSprite = self.childNode(withName: "Player") as? SKSpriteNode
        
        if let playerSprite = self.playerSprite {
            self.prevPosition = playerSprite.position
        }
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }


    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        /* if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        } */

        if let playerSprite = self.playerSprite, var prevPosition = self.prevPosition{
            prevPosition.y += 0.5
            let newPos = point2DToIso(p: prevPosition)
            playerSprite.position = newPos
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
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
        if let playerSprite = self.playerSprite, var _ = self.prevPosition{
            self.prevPosition!.y += 0.5
            let newPos = point2DToIso(p: self.prevPosition!)
            playerSprite.position = newPos
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
