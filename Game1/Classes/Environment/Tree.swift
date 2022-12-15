//
//  Tree.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 11/12/22.
//

import SpriteKit

class Tree: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 10, height: 10)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = -5
        self.setScale(1.5)
        self.name = "Tree"
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("albero10"),
            textureAtlas.textureNamed("albero11"),
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.5)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
