//
//  Animation.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/15/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import Foundation
import SpriteKit

class Animation {
    let frames : [SKTexture]
    let endFrame: Int
    var currentFrame : Int
    
    init(_ frames: [SKTexture]) {
        self.frames = frames
        self.endFrame = frames.count
        self.currentFrame = 0
    }
    
    func nextFrame() -> SKTexture {
        let out = frames[currentFrame]
        
        if currentFrame >= endFrame {
            currentFrame = 0
        } else {
            currentFrame += 1
        }
        
        return out
    }
}
