//
//  GameViewController.swift
//  Game1
//
//  Created by Nicola Rigoni on 07/12/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = LaunchScene(fileNamed: "LaunchScene") { // if let scene = SKScene(fileNamed: "GameScene")
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                //scene.size = view.bounds.size
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
