//
//  Platform.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 11/12/22.
//

import SpriteKit


class PlatformType: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 500, height: 200)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var notAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 4
        self.setScale(1.5)
        self.name = "PlatformType"
        let bodyTexture = textureAtlas.textureNamed("pezzo1")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.ground
        
        self.run(notAnimation)
    }
    
    func createAnimation() {
        let platFrames: [SKTexture] = [
            textureAtlas.textureNamed("pezzo1")
        ]
        
        let notAction = SKAction.animate(with: platFrames, timePerFrame: 1)
        
        notAnimation = SKAction.repeatForever(notAction)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
