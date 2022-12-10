//
//  Background.swift
//  Game1
//
//  Created by Nicola Rigoni on 07/12/22.
//

import SpriteKit

class Background: SKSpriteNode {
        var movementMultiplier = CGFloat(0)
        var jumpAdjustment = CGFloat(0)
        let backgroundSize = CGSize(width: 1334, height: 750)
        var textureAtlas = SKTextureAtlas(named: "Background")
    
        func spawn(parentNode:SKNode, imageName:String,
                   zPosition:CGFloat, movementMultiplier:CGFloat) {
            self.anchorPoint = CGPoint.zero
            self.position = CGPoint(x: 0, y: 30)
            self.zPosition = zPosition
            self.movementMultiplier = movementMultiplier
            parentNode.addChild(self)
            let texture = textureAtlas.textureNamed(imageName)
            
            for i in -1...1 {
                let newBGNode = SKSpriteNode(texture: texture)
                newBGNode.size = backgroundSize
                newBGNode.anchorPoint = CGPoint.zero
                newBGNode.position = CGPoint(
                    x: i * Int(backgroundSize.width), y: 0)
                self.addChild(newBGNode)
            }
    }
    

    func updatePosition(playerProgress:CGFloat) {
        let adjustedPosition = jumpAdjustment + playerProgress *
            (1 - movementMultiplier)
        if playerProgress - adjustedPosition >
            backgroundSize.width {
            jumpAdjustment += backgroundSize.width
        }
        self.position.x = adjustedPosition
    }

    
    
}
