//
//  PowerUp.swift
//  Game1
//
//  Created by Nicola Rigoni on 10/12/22.
//

import SpriteKit

class PowerUp: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var animation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 3
        self.setScale(1.5)
        self.name = "PowerUp"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.powerUp
        
        self.run(animation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("star"),
            textureAtlas.textureNamed("star")
        ]
        
        let action = SKAction.animate(with: enemiesFrames, timePerFrame: 0.14)
        
        animation = SKAction.repeatForever(action)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
