//
//  Bat.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 10/12/22.
//

import SpriteKit

class Bat: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 60, height: 40)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 3
        self.setScale(1.5)
        self.name = "Enemy"
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width / 2) - 10) //(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.enemy
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("bat104"),
            textureAtlas.textureNamed("bat105"),
            textureAtlas.textureNamed("bat106"),
            textureAtlas.textureNamed("bat107"),
            textureAtlas.textureNamed("bat108"),
            
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.2)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
