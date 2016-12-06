//
//  GameViewController.swift
//  JumpAndSlashMan
//
//  Created by Alex Ling on 12/1/16.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    private var gcEnabled: Bool?
    private var gcDefaultLeaderBoard: String?
    private var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
                gameScene = scene as! GameScene
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        authenticateLocalPlayer()
    }
    
    // borrowed example code
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: Error?) -> Void in
                    if let legitError = error {
                        print(legitError)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                        print(self.gcDefaultLeaderBoard!)
                        self.gameScene!.leaderboardIdentifier = self.gcDefaultLeaderBoard
                    }
                })
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                if let legitError = error {
                        print(legitError)
                }
            }
            
        }
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("Done!")
        let player = GKLocalPlayer()
        print("Player Authentication? " + String(player.isAuthenticated))
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
