//
//  HUD.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 10/12/22.
//

import SpriteKit

class HUD: SKNode {
    var textureAtlas = SKTextureAtlas(named:"HUD")
    //var coinAtlas = SKTextureAtlas(named: "Environment")
    var heartNodes:[SKSpriteNode] = []
    
    func createHearts(screenSize: CGSize) {
        for _ in 0 ..< 3 {
            let newHeartNode = SKSpriteNode(texture:
                                                textureAtlas.textureNamed("heart-full"))
            newHeartNode.size = CGSize (width: 46,
                                        height: 40)
            newHeartNode.position = CGPoint(x: 100, y: 550)
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
        
    }
    func setHealthDisplay(newHealth:Int) {
        let fadeAction = SKAction.fadeAlpha(to: 0.2,
                                            duration: 0.3)
        for index in 0 ..< heartNodes.count {
            if index < newHealth {
                heartNodes[index].alpha = 1
            }
            else {
                heartNodes[index].run(fadeAction)
            }
        }
    }
}
