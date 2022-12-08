//
//  Player.swift
//  Game1
//
//  Created by Nicola Rigoni on 07/12/22.
//


import SpriteKit


struct ColliderType {
    static let player: UInt32 = 1
    static let ground: UInt32 = 2
    static let enemy: UInt32 = 3
    static let powerUp: UInt32 = 4
}

class Player: SKSpriteNode, GameSprite {
    
    
    
    var initialSize: CGSize = CGSize(width: 100, height: 100)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Player")
    var catAnimation: SKAction = SKAction()
    
    
    var jump: Bool = false
    
    init() {
        
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        
        //let bodyTexture = textureAtlas.textureNamed("2")
        self.name = "Player"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)  //(texture: bodyTexture, size: self.size)
        self.physicsBody?.linearDamping = 0.9
        //self.physicsBody?.mass = 10
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.player
        self.physicsBody?.collisionBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp
        self.physicsBody?.contactTestBitMask = ColliderType.ground | ColliderType.enemy | ColliderType.powerUp
        
        self.run(catAnimation)
    }
    
    func update() {
            
        self.position.x += 4
       // if jump {
//            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 700.0))
//            let delay = SKAction.wait(forDuration: 0.2)
//            self.run(delay) {
//                self.jump = false
//            }
            
            //jumpAction()
       // }
            
    }
    
    func jumpAction() {
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 240.0))
    }
    
    func createAnimation() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.2)
        rotateDownAction.timingMode = .easeIn
        
        let catFrames: [SKTexture] = [textureAtlas.textureNamed("1"),
                                      textureAtlas.textureNamed("2"),
                                      textureAtlas.textureNamed("3")]
        
        let catAction = SKAction.animate(with: catFrames, timePerFrame: 0.3)
        catAnimation = SKAction.group([SKAction.repeatForever(catAction), rotateUpAction])
        
    }
    
    
    func onTap() {
//        let up = SKAction.moveBy(x: 0.0, y: frame.size.height, duration: 0.8)
//        self.physicsBody?.affectedByGravity = false
//        self.run(up) {
//            self.physicsBody?.affectedByGravity = true
//        }
        //self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 200.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
