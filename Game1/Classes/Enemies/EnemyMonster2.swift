//
//  EnemyMonster2.swift
//  Game1
//
//  Created by Marta Michelle Caliendo on 15/12/22.
//

import SpriteKit

class EnemyMonster2: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 75, height: 35)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    var moveMonster = SKAction()
    
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 5
        self.setScale(1.5)
        self.name = "Enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.enemy
        
        self.run(flyAnimation)
        self.run(moveMonster)
    }
    
    func createAnimation() {
        let enemiesFrames: [SKTexture] = [
            textureAtlas.textureNamed("monsterframe1"),
            textureAtlas.textureNamed("monsterframe2")
        ]
        
        let flyAction = SKAction.animate(with: enemiesFrames, timePerFrame: 0.10)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        
        let pathDown = SKAction.moveBy(x: 0, y: 150, duration: 2)
        let pathUp = SKAction.moveBy(x: 0, y: -150, duration: 2)
        let flightOfTheMonster = SKAction.sequence([pathDown, pathUp])
        
        moveMonster = SKAction.repeatForever(flightOfTheMonster)
        
    }
    
    func playSound() {
        let enemySound = SKAction.playSoundFileNamed("mixkit-creature-cry-of-hurt-2208",
                                    waitForCompletion: false)
        self.run(enemySound)
    }
    
    func onTap() { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
