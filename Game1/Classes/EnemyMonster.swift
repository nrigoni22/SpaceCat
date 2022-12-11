//
//  EnemyMonster.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 11/12/22.
//

import SpriteKit

class EnemyMonster: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 75, height: 35)
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
            textureAtlas.textureNamed("monsterframe1"),
            textureAtlas.textureNamed("monsterframe2")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.10)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

