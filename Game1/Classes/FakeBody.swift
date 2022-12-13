//
//  FakeBody.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 12/12/22.
//

import SpriteKit

class FakeBody: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 100, height: 10)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .black, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 3
        self.setScale(1.5)
        self.name = "FakeBody"
        let bodyTexture = textureAtlas.textureNamed("pezzo2")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.fake
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("nothing"),
           // textureAtlas.textureNamed("pezzo2")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.14)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
