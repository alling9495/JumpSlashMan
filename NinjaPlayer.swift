//
//  NinjaPlayer.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/15/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import Foundation
import SpriteKit

class NinjaPlayer {
    
    let attackNE : Animation
    let attackNW : Animation
    let attackSW : Animation
    let attackSE : Animation
    
    let moveNE : Animation
    let moveNW : Animation
    let moveSW : Animation
    let moveSE : Animation
    
    init () {
        let nFrames = ninjaFrames()
        
        attackNE = Animation(nFrames.attack_ne())
        attackNW = Animation(nFrames.attack_nw())
        attackSW = Animation(nFrames.attack_sw())
        attackSE = Animation(nFrames.attack_se())
        
        moveNE = Animation(nFrames.running_ne())
        moveNW = Animation(nFrames.running_nw())
        moveSE = Animation(nFrames.running_se())
        moveSW = Animation(nFrames.running_sw())
    }
    

    
}
