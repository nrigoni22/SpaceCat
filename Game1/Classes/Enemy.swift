//
//  Enemy.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 07/12/22.
//

import SpriteKit

class Enemy: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 3
        self.setScale(1.5)
        self.name = "Enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.enemy
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("bee"),
            textureAtlas.textureNamed("bee-fly")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.14)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
