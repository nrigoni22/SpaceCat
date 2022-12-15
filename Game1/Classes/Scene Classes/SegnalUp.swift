//
//  SegnalUp.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 15/12/22.
//

import SpriteKit


class SegnalUp: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 60, height: 70)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var notAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 1
        self.setScale(1.5)
        self.zPosition = 3
        
        self.run(notAnimation)
    }
    
    func createAnimation() {
        let platFrames: [SKTexture] = [
            textureAtlas.textureNamed("cartello")
        ]
        
        let notAction = SKAction.animate(with: platFrames, timePerFrame: 1)
        
        notAnimation = SKAction.repeatForever(notAction)
        
        
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
