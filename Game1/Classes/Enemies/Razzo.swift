//
//  Razzo.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 12/12/22.
//


import SpriteKit

class Razzo: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 220, height: 200)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = -4
        self.setScale(1.5)
        self.name = "Razzo"
        let bodyTexture = textureAtlas.textureNamed("razzo2")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.enemy
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("razzo1"),
            textureAtlas.textureNamed("razzo2")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.15)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
