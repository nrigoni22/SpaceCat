//
//  Plat5.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 12/12/22.
//

import SpriteKit


class Plat5: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 500, height: 150)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var notAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 3
        self.setScale(1.5)
        self.zPosition = 3
        self.name = "PlatformType"
        let bodyTexture = textureAtlas.textureNamed("pezzo5")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: CGSize(width: self.size.width - 20, height: self.size.height - 40))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.ground
        
        self.run(notAnimation)
    }
    
    func createAnimation() {
        let platFrames: [SKTexture] = [
            textureAtlas.textureNamed("pezzo5")
        ]
        
        let notAction = SKAction.animate(with: platFrames, timePerFrame: 1)
        
        notAnimation = SKAction.repeatForever(notAction)
        
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
