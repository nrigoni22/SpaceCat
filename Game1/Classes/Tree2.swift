//
//  Tree2.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 14/12/22.
//

import SpriteKit

class Tree2: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 10, height: 10)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = -5
        self.setScale(1.5)
        self.name = "Tree2"
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("albero20"),
            textureAtlas.textureNamed("albero21"),
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.5)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
