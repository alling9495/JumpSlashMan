//
//  UIDiagonalSwipeGestureRecognizer.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/4/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class DiagonalSwipeRecognizer: UIGestureRecognizer {
    
    enum Dir {
        case ne
        case nw
        case se
        case sw
    }
    
    private var startPoint: CGPoint?
    private var endPoint: CGPoint?
    public var direction = Dir.ne
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        // does not support multi-touch
        if touches.count != 1 {
            state = .failed
        } else if (state == .possible){
            state = .began
            let window = view?.window
            self.startPoint = touches.first!.location(in: window)
            //print("DiagTouchBegan " + self.startPoint!.x.description + " " + self.startPoint!.y.description)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        let window = view?.window
        self.endPoint = touches.first!.location(in: window)
        
        let adjustedEndPoint = endPoint! - startPoint!
        //print("Adjusted " + adjustedEndPoint.x.description + " " + adjustedEndPoint.y.description)
        
        var dirCheck: (CGPoint) -> Bool
        switch direction {
        case Dir.ne:
            dirCheck = northEast
        case Dir.nw:
            dirCheck = northWest
        case Dir.se:
            dirCheck = southEast
        case Dir.sw:
            dirCheck = southWest
        }
        
        if (northEast(adjustedEndPoint)) {
            direction = Dir.ne
        }
        
        if (northWest(adjustedEndPoint)) {
            direction = Dir.nw
        }
        
        if (southEast(adjustedEndPoint)) {
            direction = Dir.se
        }
        
        if (southWest(adjustedEndPoint)) {
            direction = Dir.sw
        }
        
        state = .ended
    }
        
    override func reset() {
        super.reset()
        state = .possible
    }
    
    private func northEast(_ modPoint: CGPoint) -> Bool { return modPoint.x > 0 && modPoint.y < 0 }
    private func northWest(_ modPoint: CGPoint) -> Bool { return modPoint.x < 0 && modPoint.y < 0 }
    private func southEast(_ modPoint: CGPoint) -> Bool { return modPoint.x > 0 && modPoint.y > 0 }
    private func southWest(_ modPoint: CGPoint) -> Bool { return modPoint.x < 0 && modPoint.y > 0 }
        
    
}
