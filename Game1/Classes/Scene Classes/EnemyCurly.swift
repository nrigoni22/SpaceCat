//
//  EnemyCurly.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 12/12/22.
//

import SpriteKit

class EnemyCurly: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 70, height: 65)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 3
        self.setScale(1.5)
        self.name = "Enemy"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2 - 25)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.enemy
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("piantaNemica1"),
            textureAtlas.textureNamed("piantaNemica2")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.3)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
