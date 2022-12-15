//
//  Arachnoid.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 15/12/22.
//

import SpriteKit

class Arachnoid: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 90, height: 45)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var runAnimation = SKAction()
    var moveAnimation = SKAction()
    
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 5
        self.setScale(1.5)
        self.name = "Enemy"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.enemy
        
        self.run(runAnimation)
        self.run(moveAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("inse1"),
            textureAtlas.textureNamed("inse2"),
            textureAtlas.textureNamed("inse3")
        ]
        
        let texture = SKAction.animate(with: enemiesFrames, timePerFrame: 0.14)
        runAnimation = SKAction.repeatForever(texture)
        
        let pathLeft = SKAction.moveBy(x: -200, y: -10, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 10, duration: 2)
        
        let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0)
        let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0)
        
        let arachnoidRun = SKAction.sequence([pathLeft,
        flipTextureNegative, pathRight, flipTexturePositive])
        
        moveAnimation = SKAction.repeatForever(arachnoidRun)
        
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
