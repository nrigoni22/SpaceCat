//
//  Tree.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 11/12/22.
//

import SpriteKit

class Tree: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 150, height: 150)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 0
        self.setScale(1.5)
        self.name = "Tree"
        
        self.run(flyAnimation)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("tree1"),
            textureAtlas.textureNamed("tree2"),
            textureAtlas.textureNamed("tree3"),
            textureAtlas.textureNamed("tree4")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.14)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
    }
    
    func onTap() {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
